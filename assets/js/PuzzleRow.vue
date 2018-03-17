<template>
  <div class="uk-grid-small uk-margin" uk-grid>
    <div class="uk-width-1-5">
      <textarea v-model="cell0" class="uk-textarea" v-if="!isHeaderRow" placeholder="Diagnosis"></textarea>
      <b v-if="isHeaderRow">Diagnosis</b>
    </div>
    <div class="uk-width-1-5">
      <textarea v-model="cell1" class="uk-textarea" :placeholder="placeholder"></textarea>
    </div>
    <div class="uk-width-1-5">
      <textarea v-model="cell2" class="uk-textarea" :placeholder="placeholder"></textarea>
    </div>
    <div class="uk-width-1-5">
      <textarea v-model="cell3" class="uk-textarea" :placeholder="placeholder"></textarea>
    </div>
    <div class="uk-width-1-5">
      <textarea v-model="cell4" class="uk-textarea" :placeholder="placeholder"></textarea>
    </div>
  </div>
</template>

<script>
export default {
  props: ["rowContent", "isHeaderRow"],
  data () {
    return {
      cell0: this.rowContent[0],
      cell1: this.rowContent[1],
      cell2: this.rowContent[2],
      cell3: this.rowContent[3],
      cell4: this.rowContent[4]
    }
  },
  computed: {
    placeholder: function() {
      return this.isHeaderRow ? "Column Header" : "Answer Cell"
    }
  },
  methods: {
    getContent() {
      return [
        this.cell0,
        this.cell1,
        this.cell2,
        this.cell3,
        this.cell4
      ]
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
