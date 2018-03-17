<template>
  <div>
    <button v-on:click="invite(2)">Click</button>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  //name: 'main',
  data () {
    return {
      msg: 'World!'
    }
  },
  methods: {
    invite(id) {
      axios.post('/users/'+id, {
        _csrf_token: CSRF
      }).then(function (response) {
        console.log(response);
      })
      .catch(function (error) {
        console.log(error);
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
