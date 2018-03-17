<template>
  <div>
    <div class="uk-alert-danger" v-if="is_error">
      Did not save. Please ensure all fields are filled in.
    </div>
    <form :action="form_action" method="post" v-on:submit="onSubmit()">
      <input type="hidden" name="_method" value="put" v-if="!is_new" />
      <input type="hidden" name="_csrf_token" v-model="csrf" />
      <div>
        <h3>Title</h3>
        <p>
          <input type="text" v-model="title" id="puzzle_title" name="puzzle[title]"
            class="uk-input" />
        </p>
      </div>
      <div>
        <h3>Content</h3>
        <p class="uk-margin-medium-bottom">
          <b>Number of Diagnoses</b>
          <label><input type="radio" class="uk-radio" name="puzzle[row_count]" value="4" v-model="rowCount" /> 4</label>
          <label><input type="radio" class="uk-radio" name="puzzle[row_count]" value="5" v-model="rowCount" /> 5</label>
          <label><input type="radio" class="uk-radio" name="puzzle[row_count]" value="6" v-model="rowCount" /> 6</label>
        </p>
        <p style="display:none">
          <textarea id="puzzle_content" name="puzzle[content]"
            class="uk-textarea"></textarea>
        </p>
      </div>

      <div v-for="(row, index) in content">
        <div v-if="index == 0">
          <PuzzleRow :rowContent="row" :isHeaderRow="true" ref="row"/>
        </div>
        <div v-else>
          <div v-if="index <= rowCount">
            <PuzzleRow :rowContent="row" :isHeaderRow="false" ref="row"/>
          </div>
        </div>
      </div>

      <div class="uk-margin">
        <button type="submit" class="uk-button uk-button-primary">Save</button>
        <a href="/puzzles" class="uk-button uk-button-default">Cancel</a>
      </div>
    </form>
  </div>
</template>

<script>
import PuzzleRow from './PuzzleRow.vue'

export default {
  //name: 'main',
  components: { PuzzleRow },
  data () {
    return {
      title: TITLE,
      content: CONTENT,
      rowCount: ROW_COUNT,
      csrf: CSRF
    }
  },
  computed: {
    is_new: function() {
      return ID == 0
    },
    is_error: function() {
      if (IS_INVALID != "") {
        return true
      } else {
        return false
      }
    },
    form_action: function () {
      if (this.is_new) {
        return "/puzzles"
      } else {
        return "/puzzles/" + ID
      }
    }
  },
  methods: {
    onSubmit: function () {
      var content = []
      for (var i = 0; i < 7; i++) {
        if (this.$refs.row[i]) {
          content.push(this.$refs.row[i].getContent())
        } else {
          content.push(["","","","",""])
        }
      }
      document.getElementById('puzzle_content').value = JSON.stringify(content)
    }
  },
  getRef: function(index) {
    return 'row' + index
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
