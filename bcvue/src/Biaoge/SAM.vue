<template>
  <div class="box">
    <div class="card1">
      <div id="leftbox">
        <h1>解读SAM Flag</h1>
        This utility explains SAM flags in plain English. <br>
        <br>
        <el-form>
          Flag: &nbsp;
          <input id="tb" type="text" size="10"> &nbsp; &nbsp; &nbsp;
          <input type="submit" value="Explain" @click="explainFlags(); return false;"><br>
<!--          <input type="submit" :placeholder="num"  @click="explainFlags(); return false;"><br>-->
          <br>
          Explanation:<br>
          <input type="checkbox" name="cb0" id="cb0" onclick="checkboxClicked();">
          &nbsp; read paired
          <br>
          <input type="checkbox" name="cb1" id="cb1" onclick="checkboxClicked();">
          &nbsp; read mapped in proper pair
          <br>
          <input type="checkbox" name="cb2" id="cb2" onclick="checkboxClicked();">
          &nbsp; read unmapped
          <br>
          <input type="checkbox" name="cb3" id="cb3" onclick="checkboxClicked();">
          &nbsp; mate unmapped
          <br>
          <input type="checkbox" name="cb4" id="cb4" onclick="checkboxClicked();">
          &nbsp; read reverse strand
          <br>
          <input type="checkbox" name="cb5" id="cb5" onclick="checkboxClicked();">
          &nbsp; mate reverse strand
          <br>
          <input type="checkbox" name="cb6" id="cb6" onclick="checkboxClicked();">
          &nbsp; first in pair
          <br>
          <input type="checkbox" name="cb7" id="cb7" onclick="checkboxClicked();">
          &nbsp; second in pair
          <br>
          <input type="checkbox" name="cb8" id="cb8" onclick="checkboxClicked();">
          &nbsp; not primary alignment
          <br>
          <input type="checkbox" name="cb9" id="cb9" onclick="checkboxClicked();">
          &nbsp; read fails platform/vendor quality checks
          <br>
          <input type="checkbox" name="cb10" id="cb10" onclick="checkboxClicked();">
          &nbsp; read is PCR or optical duplicate
          <br>
          <br>
          Summary:<br>
          <div id="summary">
          </div>
        </el-form>
      </div>
      <div id="rightbox"></div>
    </div>
  </div>

</template>

<script>
export default {
  name: "SAM",
  data(){
    return{
      num:'',
      two:[1,2,4,8,16,32,64,128,256,512,1024,2048],
      result:[],
      lstFlags: [["read paired", 0x1],
        ["read mapped in proper pair", 0x2],
        ["read unmapped", 0x4],
        ["mate unmapped", 0x8],
        ["read reverse strand", 0x10],
        ["mate reverse strand", 0x20],
        ["first in pair", 0x40],
        ["second in pair", 0x80],
        ["not primary alignment", 0x100],
        ["read fails platform/vendor quality checks", 0x200],
        ["read is PCR or optical duplicate", 0x400]]
    }
  },
  mounted(){
    // for(var i = 0; i < this.lstFlags.length; i++) {
    //   document.write("<input type=checkbox name=cb" + i + " id='cb" + i + "' onclick='checkboxClicked();'> &nbsp; " +this.lstFlags[i][0] + "</input><br>");
    // }
  },
  methods:{
    explainFlags() {
      var flagValue = parseInt(document.getElementById('tb').value); //returns 0 or NaN if can't parse
      var summary = "";
      for(var i = 0; i < this.lstFlags.length; i++) {
        var checkbox = document.getElementById('cb' + i)
        if(this.lstFlags[i][1] & flagValue) {
          summary += " &nbsp; &nbsp; " + this.lstFlags[i][0] + "<br>";
          checkbox.checked = true;
        } else {
          checkbox.checked = false;
        }
      }

      document.getElementById('summary').innerHTML = summary;

    },

    checkboxClicked() {
//compute the new flag value
      var newFlagValue = 0;
      for(var i = 0; i < this.lstFlags.length; i++) {
        var checkBox = document.getElementById('cb' + i);
        if(checkBox.checked) {
          newFlagValue |= this.lstFlags[i][1];
        }
      }
      var textbox = document.getElementById('tb');
      textbox.value = newFlagValue;
      this.explainFlags();
    }
  }

}
</script>

<style scoped>
.box {
  background: url('../assets/back.png');
  width: 100%;
  height: auto;
  position: absolute;
  z-index: -1;
  background-size: cover;
  left: 0;
}
.card1{
  width: 80%;
  height: auto;
  margin: 0 auto;
  display: flex;
  background: #409EFF;
}
#leftbox{
  width: 50%;
  height: auto;
  background: white;
  padding: 5px 15px 10px 15px;
  border-radius:40px 0 0 40px;
}
#rightbox{
  width: 50%;
  height: 100%;
  background: #c1c1c1;
  padding: 5px 15px 10px 15px;
  border-radius:0 40px 40px 0;
}
#line{
  margin: 10px auto;
  text-align: center;
  color: white;
}
#echart1 {
  height: 1000px;
  width: 768px;
  margin: 10px auto;
  background: #ffffff;
}
.b2{
  height: auto;
  width: auto;
  margin: 10px auto;
  display: flex;
  flex-direction: column;
}
.output{
  margin: 10px auto;
}

</style>

<style>
.element.style{
  height: 0!important;
}
html,body {
  width: 100%;
  height: auto;
}
</style>

