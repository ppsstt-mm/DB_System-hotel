<template>
  <div>
    <el-upload
      class="avatar-uploader"
      :action="getActionUrl"
      name="file"
      :headers="header"
      :show-file-list="false"
      :on-success="uploadSuccess"
      :on-error="uploadError"
      :before-upload="beforeUpload"
    />

    <quill-editor
      ref="myQuillEditor"
      class="editor"
      v-model="currentValue"
      :options="editorOption"
      @blur="onEditorBlur"
      @focus="onEditorFocus"
      @change="onEditorChange"
    />
  </div>
</template>

<script>
import { quillEditor } from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

const toolbarOptions = [
  ['bold', 'italic', 'underline', 'strike'],
  ['blockquote', 'code-block'],
  [{ header: 1 }, { header: 2 }],
  [{ list: 'ordered' }, { list: 'bullet' }],
  [{ script: 'sub' }, { script: 'super' }],
  [{ indent: '-1' }, { indent: '+1' }],
  [{ size: ['small', false, 'large', 'huge'] }],
  [{ header: [1, 2, 3, 4, 5, 6, false] }],
  [{ color: [] }, { background: [] }],
  [{ font: [] }],
  [{ align: [] }],
  ['clean'],
  ['link', 'image', 'video']
]

export default {
  components: {
    quillEditor
  },
  props: {
    value: {
      type: String,
      default: ''
    },
    action: {
      type: String,
      default: 'file/upload'
    },
    maxSize: {
      type: Number,
      default: 4000
    }
  },
  data() {
    return {
      currentValue: this.value,
      quillUpdateImg: false,
      editorOption: {
        placeholder: '',
        theme: 'snow',
        modules: {
          toolbar: {
            container: toolbarOptions,
            handlers: {
              image(value) {
                if (value) {
                  const input = document.querySelector('.avatar-uploader input')
                  if (input) input.click()
                } else {
                  this.quill.format('image', false)
                }
              }
            }
          }
        }
      },
      header: {
        Token: this.$storage.get('Token')
      }
    }
  },
  computed: {
    getActionUrl() {
      return `/${this.$base.name}/` + this.action
    }
  },
  watch: {
    value(val) {
      if (val !== this.currentValue) {
        this.currentValue = val
      }
    }
  },
  methods: {
    onEditorBlur() {},
    onEditorFocus() {},
    onEditorChange() {
      this.$emit('input', this.currentValue)
    },
    beforeUpload(file) {
      const isLtMax = file.size / 1024 <= this.maxSize
      if (!isLtMax) {
        this.$message.error(`Upload image size must be <= ${this.maxSize}KB`)
        return false
      }
      this.quillUpdateImg = true
      return true
    },
    uploadSuccess(res) {
      const quill = this.$refs.myQuillEditor && this.$refs.myQuillEditor.quill
      if (!quill) {
        this.quillUpdateImg = false
        return
      }
      if (res && res.code === 0) {
        const range = quill.getSelection(true)
        const length = range ? range.index : quill.getLength()
        quill.insertEmbed(length, 'image', this.$base.url + 'upload/' + res.file)
        quill.setSelection(length + 1)
      } else {
        this.$message.error('Image insert failed')
      }
      this.quillUpdateImg = false
    },
    uploadError() {
      this.quillUpdateImg = false
      this.$message.error('Image insert failed')
    }
  }
}
</script>

<style>
.editor {
  line-height: normal !important;
}

.ql-snow .ql-tooltip[data-mode="link"]::before {
  content: "Please enter link:";
}

.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
  border-right: 0;
  content: 'Save';
  padding-right: 0;
}

.ql-snow .ql-tooltip[data-mode="video"]::before {
  content: "Please enter video url:";
}

.ql-container {
  height: 400px;
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
  content: '14px';
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {
  content: '10px';
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {
  content: '18px';
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {
  content: '32px';
}
</style>
