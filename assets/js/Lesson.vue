<template>
  <div class="uk-margin" v-if="!is_read">
    <!--
      <button v-on:click="mark()" class="uk-button uk-button-small uk-button-primary">Mark as Read</button>
    -->
  </div>
</template>

<script>
import { applyDict } from './util.js'
import axios from 'axios'
export default {
  //name: 'main',
  data () {
    return {
      dict: DICT,
      is_read: IS_READ
    }
  },
  methods: {
    mark() {
      var self = this
      axios.post('/control/'+LESSON_ID+'/mark', {
        _csrf_token: CSRF
      }).then(function (response) {
        self.is_read = true
      })
      .catch(function (error) {
        alert('network error. contact sys admin.');
      });
    }
  },
  created() {
    var newContent = applyDict(document.getElementById('content').innerHTML, this.dict)
    document.getElementById('content').innerHTML = newContent
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.dict-term {
  border-bottom: 1px dashed #00cc00;
  color: #00cc00;
}
</style>
