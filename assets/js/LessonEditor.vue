<template>
  <div>
    <h3>Title</h3>
    <p>
      <input class="uk-input" id="lesson_title" name="lesson[title]" v-model="title" />
    </p>
    <h3>Content</h3>
    <quillEditor v-model="content"
      ref="responseInput"
      :options="responseEditorOptions" />
    <textarea style="display:none" id="lesson_content" name="lesson[content]">{{ content}}</textarea>
    <p>
      <button class="uk-button uk-button-primary" type="submit">Save</button>
      <a href="/lessons" class="uk-button uk-button-default">Cancel</a>
    </p>
    <p><i>Preview has been removed and the editor above has been updated stylistically to relfect the actual result.</i></p>
  </div>
</template>

<script>
import { quillEditor } from 'vue-quill-editor'
import { defaultQuillModules } from './quill/defaults.js'

export default {
  //name: 'main',
  components: { quillEditor },
  data () {
    return {
      title: TITLE,
      content: CONTENT,
      responseEditorOptions: {
        modules: defaultQuillModules,
        placeholder: "Enter the content of the lesson here."
      }
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>


</style>
