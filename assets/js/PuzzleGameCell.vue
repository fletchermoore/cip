<template>
  <div :id="cellId" v-on:click="selectCell" v-on:mouseover="highlight" v-on:mouseout="unhighlight"
    :class="{ cell: true, highlighted: isHighlighted, disabled: isDisabled, wrong: isWrong }">
    <div>
      <div v-if="isHeader" class="header">
        <b>{{ this.cellContent[0] }}</b>
      </div>
      <draggable class="inner-cell" v-else @start="onDragStart" @end="onDragEnd" :move="onMove" v-model="cellContent" :options="{ group: cellGroup[this.col], ghostClass: 'ghost', dragClass: 'drag' }" @add="onAdd">
        <div class="uk-drag" v-for="item in cellContent" v-html="item"></div>
      </draggable>
    </div>
  </div>
</template>

<script>
import UIKit from 'uikit'
import draggable from 'vuedraggable'
import axios from 'axios'

export default {
  components: { draggable },
  props: ["row", "col"],
  data () {
    return {
      isMousedOver: false,
      answerCard: {
        height: window.innerHeight + 'px',
        backgroundColor: 'orange'
      },
      pendingList: [""],
      cellGroup: ['untitled','first','second','third','fourth']
    }
  },
  computed: {
    cellId () {
      return 'cell-' + this.row + '-' + this.col;
    },
    isDisabled() {
      let activeCell = this.$store.state.activeCell
      if (!activeCell || this.isHeader) {
        return false
      }
      if (this.$store.state.activeCell[1] == this.col) {
        return false
      } else {
        return true
      }
    },
    isHighlighted: function () {
      return this.isMousedOver;
    },
    isHeader: function () {
      return this.col == 0 || this.row == 0;
    },
    isWrong: function () {
      if (!this.isHeader && this.cellContent != "") {
        return this.$store.state.answerKey[this.row][this.col] != this.cellContent
      }
      return false
    },
    maxHeight: function () {
      return window.innerHeight - 40;
    },
    cellContent: {
      get () {
        return [this.$store.state.currentGrid[this.row][this.col]]
      },
      set (pendingList) {
        // called when a new list is dropped by draggable onto my precious content cell
        // we will instead store this list and update the cell content in the onAdd event
        this.pendingList = pendingList
        // meanwhile we need to set the cell empty if it is being emptied
        if (pendingList.length == 0) {
          this.$store.commit('updateCell', { answer: "", location: [this.row, this.col] })
        }
      }
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
    onMove(event) {
      this.$store.commit('stash', event.relatedContext.component.$parent)
      return true;
    },
    onAdd(event) {
      // the pending list should only contain one meaningful content item and a preceding or
      // terminating "" element
      let answer = _.find(this.pendingList, function(item) {
        return item != ""
      })
      this.$store.commit('updateCell', { answer: answer ? answer : "", location: [this.row, this.col] })
      if (this.isWin()) {
        UIKit.modal(document.getElementById('win-modal')).show()
        this.logWin()
      }
    },
    logWin: function() {
      if (!this.$store.state.isWin) {
        this.$store.commit('win')
        axios.post('/exp/'+CIP_ID+'/mark', {
          _csrf_token: CSRF
        }).then(function (response) {
          // do nothing
        })
        .catch(function (error) {
          alert('network error. contact sys admin.');
        });
      }
    },
    isWin: function () {
      var key = this.$store.state.answerKey
      var grid = this.$store.state.currentGrid
      for (var row = 1; row < key.length; row++) {
        for (var col = 1; col < 5; col++) {
          if (grid[row][col] != key[row][col]) return false
        }
      }
      return true
    },
    selectCell: function () {
      if (this.$store.state.activeCell) {
        this.$store.commit('unsetActiveCell');
      }
      else if (!this.isHeader) {
        this.$store.commit('setActiveCell', { location: [this.row, this.col], cellGroup: this.cellGroup[this.col] })
      }
    },
    onDragStart: function() {
      // open up the answers choices
      this.$store.commit('setActiveCell', { location: [this.row, this.col], cellGroup: this.cellGroup[this.col] })
      this.$store.commit('setDraggingActiveCell', true)
      this.isMousedOver = false;
    },
    highlight: function () {
      if (!this.isHeader) {
        this.isMousedOver = true;
      }
    },
    unhighlight: function () {
      this.isMousedOver = false;
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.disabled {
  background: repeating-linear-gradient(
    45deg,
    #ffffff,
    #ffffff 10px,
    #e0e0e0 2px,
    #e0e0e0 12px
  );
}
.header {
  padding: 4px 10px;
}
.cell {
  border: 1px solid #e5e5e5;
}
.inner-cell {
  /* font-size: 12px; */
  padding: 4px 10px;
  display: block;
  min-height: 80px;
}
.highlighted {
  border: 1px solid blue;
}
.wrong {
  color: #f05063;
  border: 1px solid red;
}
</style>
