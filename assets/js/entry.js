// test of webpack
import 'babel-polyfill'
import Vue from 'vue'
import Vuex from 'vuex'
import VueQuillEditor from 'vue-quill-editor'
import Start from './Start.vue'
import Test from './Test.vue'
import Dict from './Dict.vue'
import LessonEditor from './LessonEditor.vue'
import CIPs from './CIPs.vue'
import Lessons from './Lessons.vue'
import EnableButton from './EnableButton.vue'
import Lesson from './Lesson.vue'
import PuzzleEditor from './PuzzleEditor.vue'
import Login from './Login.vue'
import PuzzleGame from './PuzzleGame.vue'
import Users from './Users.vue'

import _ from "lodash"
import { applyDict } from './util.js'

import UIkit from 'uikit'
//import Icons from 'uikit/dist/js/uikit-icons'

// loads the Icon plugin
//UIkit.use(Icons)

//import 'uikit/dist/css/uikit.min.css'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
import '../css/my-quill-changes.css' // override editor defaults to match UIKit

Vue.use(VueQuillEditor)
Vue.use(Vuex)


if (document.getElementById('start-vue')) {
  var app = new Vue({
    el: '#start-vue',
    render: (f) => {
      return f(Start)
    }
  })
}

if (document.getElementById('login-vue')) {
  var app = new Vue({
    el: '#login-vue',
    render: (f) => {
      return f(Login)
    }
  })
}

if (document.getElementById('dict-vue')) {
  var app = new Vue({
    el: '#dict-vue',
    render: (f) => {
      return f(Dict)
    }
  })
}

if (document.getElementById('lesson-vue')) {
  var app = new Vue({
    el: '#lesson-vue',
    render: (f) => {
      return f(Lesson)
    }
  })
}

if (document.getElementById('lessons-vue')) {
  var app = new Vue({
    el: '#lessons-vue',
    render: (f) => {
      return f(Lessons)
    }
  })
}

if (document.getElementById('cips-vue')) {
  var app = new Vue({
    el: '#cips-vue',
    render: (f) => {
      return f(CIPs)
    }
  })
}


if (document.getElementById('test-vue')) {
  var app = new Vue({
    el: '#test-vue',
    render: (f) => {
      return f(Test)
    }
  })
}

if (document.getElementById('users-vue')) {
  var app = new Vue({
    el: '#users-vue',
    render: (f) => {
      return f(Users)
    }
  })
}

if (document.getElementById('lesson-editor')) {
  var app = new Vue({
    el: '#lesson-editor',
    render: (f) => {
      return f(LessonEditor)
    }
  })
}

if (document.getElementById('enable-button-vue')) {
  var app = new Vue({
    el: '#enable-button-vue',
    render: (f) => {
      return f(EnableButton)
    }
  })
}

if (document.getElementById('puzzle-editor')) {
  var app = new Vue({
    el: '#puzzle-editor',
    render: (f) => {
      return f(PuzzleEditor)
    }
  })
}

if (document.getElementById('puzzle-game')) {

  var content = CONTENT.slice(0, ROW_COUNT+1) // the content provided by server has maximum number of rows
    // the latter rows are just empty
  var emptyGrid = [
    ["",CONTENT[0][1],CONTENT[0][2],CONTENT[0][3],CONTENT[0][4]]
  ] // the headers
  for (var i = 1; i < ROW_COUNT+1; i++) {
    emptyGrid.push([CONTENT[i][0],"","","",""])
  }

  if (DICT) {
    for (var i = 1; i < ROW_COUNT+1; i++) {
      for (var j = 1; j < 5; j++) {
        content[i][j] = applyDict(content[i][j], DICT)
      }
    }
  }

  function stash(state, component) {

  }

  function restore(state) {
    if (state.stash && state.stash.component) {
      let oldComponent = state.stash.component
      state.currentGrid[oldComponent.row][oldComponent.col] = state.stash.content
      state.stash = false
      // trigger grid refresh
      Vue.set(state.currentGrid, 0, state.currentGrid[0]) // use meaningless set to trigger a refresh
    }
  }

  const store = new Vuex.Store({
    state: {
      activeCell: false,
      isDraggingActiveCell: false,
      activeDiagnosis: "",
      activeCellGroup: "untitled",
      isWin: false,
      currentGrid: emptyGrid,
      answerKey: content,
      randomizedChoices: [
        false,
        false,
        false,
        false
      ],
      stash: false // when dragging and dropping content elements, as you drag and hover
        // over a cell,
        // the existing content must go way (it is stored here in the stash) so that
        // we can get a swap effect going and not have the ghosts for the moves correctly
        // displayed. otherwise it just tries to set 2 items into the same cell
    },
    mutations: {
      stash(state, component) {

        // abort if asked to stash over the answer selection box
        // the given component will be wrong, not containing rows and col values
        if (!component || !component.row) {
          return false
        }

        // this function should only be called when hovering over a "new" box.
        // move event triggers multiple times on the same box. so do not execute unless
        // the hovered component is changed
        if (state.stash != false && component.row == state.stash.component.row) {
          return false // do not trigger unless you are trying to stash a different row
        }

        // do not stash if the cell being dragged is the active cell and we are
        // hovering over the active cell
        // BUT DO RESTORE
        if (state.isDraggingActiveCell && component.row == state.activeCell[0]) {
          restore(state)
          return false
        }

        let content = state.currentGrid[component.row][component.col]
        // if there is existing stash, restore it
        restore(state)
        // store the given component and its content
        state.stash = { content: content, component: component }
        // wipe out existing content in cell which is hovered over
        state.currentGrid[component.row][component.col] = ""

        // trigger grid refresh
        Vue.set(state.currentGrid, 0, state.currentGrid[0]) // use meaningless set to trigger a refresh
      },
      clearStash(state) {
        state.stash = false
        state.isDraggingActiveCell = false
      },
      win(state) {
        state.isWin = true
      },
      unsetActiveCell (state) {
        state.activeCell = false
      },
      setActiveCell (state, payload) {
        state.activeCell = payload.location
        state.activeCellGroup = payload.cellGroup
        state.activeDiagnosis = state.answerKey[state.activeCell[0]][0]
      },
      setDraggingActiveCell (state, status) {
        state.isDraggingActiveCell = status
      },
      updateCell (state, payload) {
        let x = payload.location[0]
        let y = payload.location[1]
        state.currentGrid[x][y] = payload.answer
        Vue.set(state.currentGrid, 0, state.currentGrid[0]) // use meaningless set to trigger a refresh
        state.activeCell = false // hide the answer choices
      },
      randomize (state) {
        let answers = state.answerKey
        for (var col = 1; col < 5; col++) {
          // accumulate the correct answer options
          var answerOptions = []
          // iterate over rows
          for (var i = 1; i < answers.length; i++) {
            let option = answers[i][col]
            if (option != "") { // don't add blanks to answer key
              answerOptions.push(answers[i][col])
            }
          }
          // transfer the choices at random to the choice key
          // thanks lodash!
          state.randomizedChoices[col] = _.shuffle(answerOptions)
        }
      }
    }
  })

  var app = new Vue({
    el: '#puzzle-game',
    store: store,
    render: (f) => {
      return f(PuzzleGame)
    }
  })
}
