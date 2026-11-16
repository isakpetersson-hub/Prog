
namespace Calculator
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
            this.textBox_1 = new System.Windows.Forms.TextBox();
            this.label_number1 = new System.Windows.Forms.Label();
            this.btn_plus = new System.Windows.Forms.Button();
            this.label_result = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.btn_minus = new System.Windows.Forms.Button();
            this.btn_multi = new System.Windows.Forms.Button();
            this.btn_dela = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBox_1
            // 
            this.textBox_1.Location = new System.Drawing.Point(113, 48);
            this.textBox_1.Name = "textBox_1";
            this.textBox_1.Size = new System.Drawing.Size(154, 23);
            this.textBox_1.TabIndex = 0;
            // 
            // label_number1
            // 
            this.label_number1.AutoSize = true;
            this.label_number1.Location = new System.Drawing.Point(42, 51);
            this.label_number1.Name = "label_number1";
            this.label_number1.Size = new System.Drawing.Size(65, 15);
            this.label_number1.TabIndex = 1;
            this.label_number1.Text = "Skriv ett tal";
            // 
            // btn_plus
            // 
            this.btn_plus.Location = new System.Drawing.Point(12, 134);
            this.btn_plus.Name = "btn_plus";
            this.btn_plus.Size = new System.Drawing.Size(75, 23);
            this.btn_plus.TabIndex = 2;
            this.btn_plus.Text = "+";
            this.btn_plus.UseVisualStyleBackColor = true;
            this.btn_plus.Click += new System.EventHandler(this.btn_calculate);
            this.btn_plus.Enter += new System.EventHandler(this.btn_Enter);
            this.btn_plus.Leave += new System.EventHandler(this.btn_Leave);
            // 
            // label_result
            // 
            this.label_result.AutoSize = true;
            this.label_result.Location = new System.Drawing.Point(163, 160);
            this.label_result.Name = "label_result";
            this.label_result.Size = new System.Drawing.Size(22, 15);
            this.label_result.TabIndex = 3;
            this.label_result.Text = "     ";
            this.label_result.Click += new System.EventHandler(this.label1_Click_1);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(42, 80);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 15);
            this.label1.TabIndex = 5;
            this.label1.Text = "Skriv ett tal";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(113, 77);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(154, 23);
            this.textBox1.TabIndex = 4;
            // 
            // btn_minus
            // 
            this.btn_minus.Location = new System.Drawing.Point(93, 134);
            this.btn_minus.Name = "btn_minus";
            this.btn_minus.Size = new System.Drawing.Size(75, 23);
            this.btn_minus.TabIndex = 6;
            this.btn_minus.Text = "-";
            this.btn_minus.UseVisualStyleBackColor = true;
            this.btn_minus.Click += new System.EventHandler(this.btn_calculate);
            this.btn_minus.Enter += new System.EventHandler(this.btn_Enter);
            this.btn_minus.Leave += new System.EventHandler(this.btn_Leave);
            // 
            // btn_multi
            // 
            this.btn_multi.Location = new System.Drawing.Point(186, 134);
            this.btn_multi.Name = "btn_multi";
            this.btn_multi.Size = new System.Drawing.Size(75, 23);
            this.btn_multi.TabIndex = 7;
            this.btn_multi.Text = "*";
            this.btn_multi.UseVisualStyleBackColor = true;
            this.btn_multi.Click += new System.EventHandler(this.btn_calculate);
            this.btn_multi.Enter += new System.EventHandler(this.btn_Enter);
            this.btn_multi.Leave += new System.EventHandler(this.btn_Enter);
            // 
            // btn_dela
            // 
            this.btn_dela.Location = new System.Drawing.Point(267, 134);
            this.btn_dela.Name = "btn_dela";
            this.btn_dela.Size = new System.Drawing.Size(75, 23);
            this.btn_dela.TabIndex = 8;
            this.btn_dela.Text = "/";
            this.btn_dela.UseVisualStyleBackColor = true;
            this.btn_dela.Click += new System.EventHandler(this.btn_calculate);
            this.btn_dela.Enter += new System.EventHandler(this.btn_Enter);
            this.btn_dela.Leave += new System.EventHandler(this.btn_Leave);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(354, 274);
            this.Controls.Add(this.btn_dela);
            this.Controls.Add(this.btn_multi);
            this.Controls.Add(this.btn_minus);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label_result);
            this.Controls.Add(this.btn_plus);
            this.Controls.Add(this.label_number1);
            this.Controls.Add(this.textBox_1);
            this.Name = "Form1";
            this.Text = "Mycalculator";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBox_1;
        private System.Windows.Forms.Label label_number1;
        private System.Windows.Forms.Button btn_plus;
        private System.Windows.Forms.Label label_result;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button btn_minus;
        private System.Windows.Forms.Button btn_multi;
        private System.Windows.Forms.Button btn_dela;
    }
}

