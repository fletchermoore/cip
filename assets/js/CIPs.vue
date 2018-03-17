<template>
  <div>
    <p>Instructions below will appear above the CIP list for the user.</p>
    <InstructionEditor settingName="cip-instructions"/>
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
