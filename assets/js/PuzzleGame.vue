<template>
  <div class="puzzleGame">
    <div class="puzzleContainer">
      <div v-if="this.activeCell != false" :style="answerBoxStyle" class="uk-card uk-card-default uk-card-body answerBox">
        <draggable v-model="activeAnswers" :move="hideUnderlings" @start="onDragStart" @end="onDragEnd" :options="{ group: activeCellGroup, ghostClass: 'ghost', dragClass: 'drag' }">
          <div class="answerChoice uk-drag" v-for="answer in activeAnswers" v-html="answer"></div>
        </draggable>
      </div>
      <div v-for="row in rows">
        <PuzzleGameRow :row="row" />
        <!-- <hr v-if="row < (rows.length - 1)" style="margin: 0px" /> -->
      </div>
    </div>


    <!-- This is the modal -->
    <div id="win-modal" uk-modal>
        <div class="uk-modal-dialog uk-modal-body">
            <h2 class="uk-modal-title uk-text-center">100% Correct!</h2>
            <!-- <button class="uk-modal-close" type="button"></button> -->
        </div>
    </div>

  </div>
</template>

<script>
import PuzzleGameRow from './PuzzleGameRow.vue'
import UIKit from 'uikit'
import _ from 'lodash'
import draggable from 'vuedraggable'

export default {
  components: { PuzzleGameRow, draggable },
  data () {
    return {
      placeholder: ['a','b','c','d']
    }
  },
  computed: {
    answerBoxStyle: function () {
      let w = document.getElementById('cell-1-1').offsetWidth; // add 30 for left margin of grid
      let h = document.getElementById('cell-0-1').offsetHeight;
      let activeLocation = this.$store.state.activeCell;
      if (activeLocation) {
        let col = activeLocation[1]
        if (col > 2) {
          // right-most cells
          return {
            right: '' + ((w) * (5-col) + 10) + 'px',
            top: '' + (h+10)+ 'px',
            maxHeight: window.innerHeight
          }
        } else {
          // left-most cells
          return {
            left: '' + ((w) * (col +1) + 10) + 'px',
            top: '' + (h+10)+ 'px',
            maxHeight: window.innerHeight
          }
        }
      } else {
        return {
          display: 'none'
        }
      }
    },
    rows: function () { // returns array with [0,1,2,3 ... row count]
      var len = this.$store.state.answerKey.length
      var rows = []
      for (var i = 0; i < len; i++) {
          rows.push(i)
      }
      return rows
    },
    activeCell: function () {
      return this.$store.state.activeCell
    },
    activeAnswers: {
      get() {
        var grid = this.$store.state.currentGrid
        var key = this.$store.state.answerKey
        var col = this.$store.state.activeCell[1]

        let availableAnswers = this.$store.state.randomizedChoices[col].slice()

        for (var i = 1; i < grid.length; i++) {
          var answer = grid[i][col]
          if (answer == key[i][col]) { // check to ensure this is a correct answer
                                      // incorrectly placed answers will remain in the answer choices
            // find the index of the answer in randomizedChoices
            let firstIndex = _.findIndex(availableAnswers, function(e) { return e == answer })
            if (firstIndex > -1 && availableAnswers.length > 0) {
              // creates a new array, excluding the index that was found
              availableAnswers = availableAnswers.slice(0, firstIndex).concat(availableAnswers.slice(firstIndex+1))
            }
          }
        }
        return availableAnswers
      },
      set(value) {

      }
    },
    activeCellGroup: function () {
      return this.$store.state.activeCellGroup;
    }
  },
  methods: {
    onDragStart(event) {

    },
    onDragEnd(event) {
      this.$store.commit('clearStash')
    },
    clearAnswer: function (offcanvasId) {
      this.$store.commit('updateContent', { answer: "" })
    },
    hideUnderlings(event) {
      this.$store.commit('stash', event.relatedContext.component.$parent)
      return true;
    }
  },
  mounted() {
    this.$store.commit('randomize')
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.small-font {
  font-size: 12px;
}

.dict-term {
  border-bottom: 1px dashed #00cc00;
  color: #00cc00;
}

.puzzleContainer {
  position: relative;
  border: 1px solid #e5e5e5;
}

.answerBox {
  z-index: 5;
  width: 300px;
  overflow: auto;
  position: absolute;
}

.answerChoice {
  padding: 10px 0px;
}

.ghost {
  display: inline;
  color: #cccccc;
}
.drag {
  color: black;
  font-weight: bold;
}
.chosen {
  color: orange;
}
</style>
