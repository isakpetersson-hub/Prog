
namespace Evil_or_nice
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxNamn = new System.Windows.Forms.TextBox();
            this.radio_evil = new System.Windows.Forms.RadioButton();
            this.radio_nice = new System.Windows.Forms.RadioButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.button_halsning = new System.Windows.Forms.Button();
            this.label_result = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(239, 66);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(40, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "Namn";
            // 
            // textBoxNamn
            // 
            this.textBoxNamn.Location = new System.Drawing.Point(285, 66);
            this.textBoxNamn.Name = "textBoxNamn";
            this.textBoxNamn.Size = new System.Drawing.Size(100, 23);
            this.textBoxNamn.TabIndex = 1;
            // 
            // radio_evil
            // 
            this.radio_evil.AutoSize = true;
            this.radio_evil.Location = new System.Drawing.Point(117, 16);
            this.radio_evil.Name = "radio_evil";
            this.radio_evil.Size = new System.Drawing.Size(46, 19);
            this.radio_evil.TabIndex = 2;
            this.radio_evil.TabStop = true;
            this.radio_evil.Text = "Elak";
            this.radio_evil.UseVisualStyleBackColor = true;
            this.radio_evil.CheckedChanged += new System.EventHandler(this.btn_evil_CheckedChanged);
            // 
            // radio_nice
            // 
            this.radio_nice.AutoSize = true;
            this.radio_nice.Location = new System.Drawing.Point(14, 16);
            this.radio_nice.Name = "radio_nice";
            this.radio_nice.Size = new System.Drawing.Size(50, 19);
            this.radio_nice.TabIndex = 3;
            this.radio_nice.TabStop = true;
            this.radio_nice.Text = "Snäll";
            this.radio_nice.UseVisualStyleBackColor = true;
            this.radio_nice.CheckedChanged += new System.EventHandler(this.btn_nice_CheckedChanged);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radio_nice);
            this.groupBox1.Controls.Add(this.radio_evil);
            this.groupBox1.Location = new System.Drawing.Point(225, 122);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(172, 82);
            this.groupBox1.TabIndex = 4;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Humör";
            // 
            // button_halsning
            // 
            this.button_halsning.Location = new System.Drawing.Point(225, 210);
            this.button_halsning.Name = "button_halsning";
            this.button_halsning.Size = new System.Drawing.Size(172, 23);
            this.button_halsning.TabIndex = 5;
            this.button_halsning.Text = "Hälsning";
            this.button_halsning.UseVisualStyleBackColor = true;
            this.button_halsning.Click += new System.EventHandler(this.btn_halsning);
            // 
            // label_result
            // 
            this.label_result.AutoSize = true;
            this.label_result.Location = new System.Drawing.Point(285, 253);
            this.label_result.Name = "label_result";
            this.label_result.Size = new System.Drawing.Size(0, 15);
            this.label_result.TabIndex = 6;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.label_result);
            this.Controls.Add(this.button_halsning);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.textBoxNamn);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxNamn;
        private System.Windows.Forms.RadioButton radio_evil;
        private System.Windows.Forms.RadioButton radio_nice;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button button_halsning;
        private System.Windows.Forms.Label label_result;
    }
}

