<template>
  <div class="uk-grid-match uk-grid-collapse" uk-grid>
    <div class="uk-width-1-5">
      <PuzzleGameCell :row="this.row" :col="0" />
    </div>
    <div class="uk-width-1-5">
      <PuzzleGameCell :row="this.row" :col="1" />
    </div>
    <div class="uk-width-1-5">
      <PuzzleGameCell :row="this.row" :col="2" />
    </div>
    <div class="uk-width-1-5">
      <PuzzleGameCell :row="this.row" :col="3" />
    </div>
    <div class="uk-width-1-5">
      <PuzzleGameCell :row="this.row" :col="4" />
    </div>
  </div>
</template>

<script>
import PuzzleGameCell from "./PuzzleGameCell.vue"
export default {
  components: { PuzzleGameCell },
  props: ["row"],
  data () {
    return {
      msg: 'World!'
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
