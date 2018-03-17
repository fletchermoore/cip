<template>
  <div>
    <p>Instructions below will appear above the lesson list for the user.</p>
    <InstructionEditor settingName="lesson-instructions"/>
  </div>
</template>

<script>
import InstructionEditor from './InstructionEditor.vue'

export default {
  components: { InstructionEditor },
  //name: 'main',
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
