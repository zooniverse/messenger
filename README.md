# Messenger

[![Build Status](https://travis-ci.org/zooniverse/messenger.svg?branch=master)](https://travis-ci.org/zooniverse/messenger)

Messenger is a Rails API that stores aggregated text transcriptions, allowing researchers to 
review, accept, and reject consensus transcriptions. It authenticates with the 
[Panoptes API](https://zooniverse.org): only project owners and collaborators 
are able to add and update transcriptions for their projects.

It is called Messenger because early in the process of gene expresssion, the transcription 
step results in 'messenger' RNA (mRNA) that is template for protien synthesis through translation.

Transcription comes first, then the messenger, then a legible and useful result!

Authorization is provided by a JWT token from Panoptes sent in the request's Authorization header. Messenger uses the [JSONAPI](http://jsonapi.org/) spec throughout.

Here are the pieces:


## Project

A Panoptes project.  `Project#id` is consistent with Panoptes project ids and should be set manually.

#### Relationships

- Has many Transcriptions

#### Attributes

| Attribute | Type   | Description |
| :-------- | :----- | :---------- |
| `slug`    | String | The project url slug |

### API

<details>
<summary><strong>GET /projects</strong></summary>

- Publicly accessible
- Filterable by `slug`

``` json
{
  "data": [{
    "id": "1",
    "type": "projects",
    "attributes": {
      "slug": "project-owner/project-name"
    },
    "links": {
      "self": "/projects/1",
      "transcriptions": "/transcriptions?filter[project_id]=1"
    }
  }],
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "/projects?page[number]=1&page[size]=1",
    "next": "/projects?page[number]=2&page[size]=1",
    "last": "/projects?page[number]=123&page[size]=1"
  }
}
```
</details>

<details>
<summary><strong>GET /projects/:id</summary>

- Publicly accessible

``` json
{
  "data": [{
    "id": "1",
    "type": "projects",
    "attributes": {
      "slug": "project-owner/project-name"
    },
    "links": {
      "self": "/projects/1",
      "transcriptions": "/transcriptions?filter[project_id]=1"
    }
  }],
  "jsonapi": {
    "version": "1.0"
  }
}
```
</details>

<details>
<summary><strong>POST /projects</strong></summary>

- Accessible by project owners, collaborators, and site admins. The id will be the same as the project's Panoptes id, `slug` is the only required parameter.

##### Schema

``` json
{
  "properties": {
    "data": {
      "properties": {
        "slug": {
          "type": "string"
        }
      },
      "type": "object",
      "required": [
        "slug"
      ],
      "additionalProperties": false
    }
  },
  "type": "object",
  "required": [
    "data"
  ]
}
```

##### Example

``` json
{
  "data": {
    "type": "projects",
    "attributes": {
      "slug": "project-owner/project-name"
    }
  }
}
```
</details>

<details>
<summary><strong>PUT /projects/:id</strong></summary>

- Not permitted
</details>

<details>
<summary><strong>DELETE /projects/:id</strong></summary>

- Not permitted
</details>


## Transcription

A text transcription of a Panoptes subject.

#### Relationships
- Belongs to Project

#### Attributes

| Attribute | Type     | Description |
| :-------- | :--------| :---------- |
| `id`      | Integer  | The Panoptes ID of the transcribed subject. |
| `status`  | String   | The current status: 'accepted', 'rejected', 'amended', or 'unreviewed'. |
| `text`    | Text     | The text content of the annotation in whatever format is required. |

### API

<details>
<summary><strong>GET /transcriptions</strong></summary>

- Scoped by project owner or collaborator roles
- Site admins can access all transcriptions
- Filterable by `project_id` and `state`

``` json
{
  "data": [{
    "id": "1",
    "type": "transcriptions",
    "attributes": {
      "state": "accepted",
      "project_id": 1,
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet sem luctus, facilisis erat sit amet, volutpat arcu. Cras ultricies malesuada quam a gravida. Mauris pulvinar ipsum eget urna vulputate pulvinar. Duis quis quam leo. Cras neque nisi, cursus at gravida nec, viverra non est. Curabitur aliquam sodales sapien. Donec commodo sodales velit, a placerat diam volutpat id. Proin tempus, leo in faucibus consequat, turpis erat molestie orci, eget ornare neque lacus et nisi. Quisque ut lobortis diam. Nulla iaculis lacus a erat feugiat tincidunt. Nulla sem purus, eleifend sit amet ipsum ac, auctor venenatis magna. Maecenas molestie ullamcorper velit luctus posuere."
    },
    "links": {
      "self": "/transcriptions/1"
    }
  }],
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "/transcriptions?page[number]=1&page[size]=1",
    "next": "/transcriptions?page[number]=2&page[size]=1",
    "last": "/transcriptions?page[number]=123&page[size]=1"
  }
}
```
</details>

<details>
<summary><strong>GET /transcriptions/:id</strong></summary>

- Publicly accessible

``` json
{
  "data": [{
    "id": "1",
    "type": "transcriptions",
    "attributes": {
      "state": "unreviewed",
      "project_id": 1,
      "text": "A bunch more text"
    },
    "links": {
      "self": "/transcriptions/1"
    }
  }],
  "jsonapi": {
    "version": "1.0"
  }
}
```
</details>

<details>
<summary><strong>POST /transcriptions</strong></summary>

- Accessible by project owners, collaborators, and site admins. ID property should be the corresponding Panoptes subject ID.

##### Schema

``` json
{
  "properties": {
    "data": {
      "properties": {
        "id": {
          "oneOf": [{
            "type": "integer",
            "minimum": 1
          }, {
            "type": "string",
            "pattern": "^[1-9]\\d*$"
          }]
        },
        "project_id": {
          "oneOf": [{
            "type": "integer",
            "minimum": 1
          }, {
            "type": "string",
            "pattern": "^[1-9]\\d*$"
          }]
        },
        "text": {
          "type": "text"
        },
        "status": {
          "enum": ["accepted", "rejected", "amended", "unreviewed"]
        }
      },
      "type": "object",
      "required": ["project_id", "status", "text"],
      "additionalProperties": false
    }
  },
  "type": "object",
  "required": ["data"]
}
```

##### Example

``` json
{
  "data": {
    "attributes": {
      "text": "Curabitur ut magna in lectus semper vulputate ac non urna. Suspendisse mattis nisi enim, non dapibus augue sodales dapibus. Donec vitae sapien at metus ultricies ullamcorper. Quisque varius posuere mauris. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In et eleifend mauris, eu sodales nibh. Mauris laoreet, justo tincidunt egestas pulvinar, ex lectus rhoncus urna, quis faucibus mauris lectus a ex.",
      "state": "unreviewed"
    },
    "relationships": {
      "project": {
        "data": {
          "type": "projects",
          "id": "1"
        }
      }
    }
  }
}
```
</details>

<details>
<summary><strong>PUT /transcriptions/:id</strong></summary>

- Accessible by project owners, collaborators, and site admins

##### Schema

``` json
{
  "properties": {
    "data": {
      "properties": {
        "project_id": {
          "oneOf": [{
            "type": "integer",
            "minimum": 1
          }, {
            "type": "string",
            "pattern": "^[1-9]\\d*$"
          }]
        },
        "text": {
          "type": "text"
        },
        "status": {
          "enum": ["accepted", "rejected", "amended", "unreviewed"]
        }
      },
      "type": "object",
      "additionalProperties": false
    }
  },
  "type": "object",
  "required": ["data"]
}
```

##### Example

``` json
{
  "data": {
    "attributes": {
      "text": "A way, way better transctiption",
      "status": "amended"
    }
  }
}
```
</details>

<details>
<summary><strong>DELETE /transcriptions/:id</strong></summary>

- Accessible by project owners, collaborators, and site admins
</details>

## How To Use Messenger, for Front End Developers

A supporting guide has been prepared for front end developers wishing to use the Messenger service: [README-FRONT-END-DEV.md](README-FRONT-END-DEV.md)
