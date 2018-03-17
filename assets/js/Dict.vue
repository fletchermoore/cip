<template>
  <div>
    <form action="/dict/update" method="post" v-on:submit="onSubmit()">
      <input type="hidden" name="_csrf_token" v-model="token" />
      <input type="hidden" name="_method" value="put">
      <textarea style="display:none" name="dict[content]" id="dict_content" class="uk-textarea"></textarea>

      <table class="uk-table">
        <tr v-for="term in orderedDict">
          <td width="25%"><b>{{ term }}</b></td>
          <td v-html="dict[term]"></td>
          <td>
            <button v-on:click.prevent="deleteTerm(term)" class="uk-button uk-button-danger uk-button-small">Delete</button>
          </td>
        </tr>
        <tr>
          <td width="25%">
            <input placeholder="Term" id="term-input" type="text" class="uk-input" focus="true" v-model="newTerm" />
          </td>
          <td>
            <input placeholder="Definition" type="text" class="uk-input" v-model="newDef" />
          </td>
          <td>
            <button v-on:click.prevent="addTerm()" class="uk-button uk-button-default">Add&nbsp;Term</button>
          </td>
        </tr>
      </table>
      <div class="uk-margin-top">
        <button type="submit" class="uk-button uk-button-primary">Save</button>
      </div>
    </form>
  </div>
</template>

<script>
import _ from 'lodash'
export default {
  //name: 'main',
  data () {
    return {
      token: CSRF,
      dict: DICT,
      newTerm: "",
      newDef: ""
    }
  },
  computed: {
    orderedDict() {
      return _.sortBy(_.keys(this.dict))
    }
  },
  methods: {
    onSubmit() {
      document.getElementById('dict_content').value = JSON.stringify(this.dict)
    },
    addTerm() {
      this.dict[this.newTerm] = _.escape(this.newDef)
      this.dict = _.extend({}, this.dict)
      this.newTerm = ""
      this.newDef = ""
      document.getElementById('term-input').focus()
    },
    deleteTerm(term) {
      delete this.dict[term]
      this.dict = _.extend({}, this.dict)
    }
  },
  mounted() {
    document.getElementById('term-input').focus()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
