<template>
  <div>
    <draggable class="dest" v-model="items" :options="{group: 'items', sort: false, ghostClass: 'none'}" @start="start">
      <div class="boxy uk-drag" v-for="item in items" :key="item">
        <a href="#" v-on:click.prevent="doclick">{{ item }}</a>
      </div>
    </draggable>

    <div class="uk-container" uk-grid>

      <draggable class="dest" v-model="dest1" :options="{group: 'items', sort: false, ghostClass: 'none'}" @add="check1" @start="start1">
        <div class="boxy uk-drag" v-for="item in dest1" :key="item">{{ item }}</div>
      </draggable>

      <draggable class="dest" v-model="dest2" :options="{group: 'items', sort: false, ghostClass: 'none'}" @add="check2" @start="start2">
        <div class="boxy uk-drag" v-for="item in dest2" :key="item">{{ item }}</div>
      </draggable>

      <draggable class="dest" v-model="dest3" :options="{group: 'items', sort: false, ghostClass: 'none'}">
        <div class="boxy uk-drag" v-for="item in dest3" :key="item">{{ item }}</div>
      </draggable>

    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable'
import _ from 'lodash'
export default {
  components: { draggable },
  data () {
    return {
      items: ['nugget','house','ginger','christmas'],
      dest1: [],
      dest2: [],
      dest3: [],
      moving: "",
      source: undefined
    }
  },
  created () {

  },
  methods: {
    doclick () {
      alert('yes')
    },
    start (evt) {
      this.moving = this.items[evt.oldIndex]
      this.source= this.items
    },
    start1 (evt) {
      this.moving = this.dest1[evt.oldIndex]
      this.source= this.dest1
    },
    start2 (evt) {
      this.moving = this.dest2[evt.oldIndex]
      this.source= this.dest1
    },
    check1 (evt) {
      if (this.dest1.length > 1) {
        console.log('added too many')
        var losers = _.difference(this.dest1, [this.moving])
        console.log(losers)
        this.dest1 = [this.moving]
        console.log(this.$data['items'], losers)
        this.$data['items'] = this.$data['items'].concat(losers)
      } else {
        console.log('ok')
      }
    },
    check2 (evt) {
      if (this.dest2.length > 1) {
        console.log('added too many')
      } else {
        console.log('ok')
      }    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.boxy {
  width: 150px;
  height: 50px;
  margin: 10px;
  background-color: #00ee00
}
.dest {
  min-width: 200px;
  min-height: 60px;
  border: 1px solid #999999;
  margin: 20px;
}
.none {
  display: none;
}
</style>
