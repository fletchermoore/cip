<template>
  <div>
    <h3>Instructions</h3>
    <quillEditor v-model="content"
      ref="responseInput"
      :options="responseEditorOptions" />
    <p>
      <button v-if="!isSaving" class="uk-button uk-button-primary" v-on:click="save()">Save</button>
      <button v-else class="uk-button uk-button-default" disabled>Saving</button>
      <span v-if="isChanged">*Unsaved Changes</span>
    </p>
  </div>
</template>

<script>
import { quillEditor } from 'vue-quill-editor'
import { defaultQuillModules } from './quill/defaults.js'
import axios from 'axios'

export default {
  //name: 'main',
  components: { quillEditor },
  props: ["settingName"],
  data () {
    return {
      content: "",
      originalContent: "",
      isSaving: false,
      responseEditorOptions: {
        modules: defaultQuillModules
      }
    }
  },
  computed: {
    isChanged: function() {
      return this.content != this.originalContent
    }
  },
  methods: {
    save() {
      var self = this
      this.isSaving = true
      axios.put('/options/'+this.settingName, {
        value: this.content,
        _csrf_token: CSRF_TOKEN
      }).then(function (response) {
        self.originalContent = self.content
        self.isSaving = false
      }).catch(function (error) {
        alert('network or server error: contact system administrator')
        self.isSaving = false
      })
    }
  },
  mounted() {
    console.log(this.settingName)
    var self = this
    axios.get('/options/'+this.settingName).then(function(response) {
      //this.content = response.data.
      if (response.data.data) {
        self.content = response.data.data.value
        self.originalContent = self.content
      }
    })
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>


</style>
