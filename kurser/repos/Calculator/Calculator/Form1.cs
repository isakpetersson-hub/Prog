using System;
using System.Windows.Forms;

namespace Calculator
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_calculate(object sender, EventArgs e)
        {
            string operation = ((Button)sender).Text;
            try
            {
                switch (operation)
                {
                    case "+":
                        label_result.Text = (double.Parse(textBox_1.Text) + double.Parse(textBox1.Text)).ToString();
                        break;

                    case "-":
                        label_result.Text = (double.Parse(textBox_1.Text) - double.Parse(textBox1.Text)).ToString();
                        break;

                    case "*":
                        label_result.Text = (double.Parse(textBox_1.Text) * double.Parse(textBox1.Text)).ToString();
                        break;

                    case "/":
                        label_result.Text = (double.Parse(textBox_1.Text) / double.Parse(textBox1.Text)).ToString();
                        break;
                }
            }
            catch (Exception ex)
            {
                label_result.Text = ex.Message;
            }
        }

        private void label1_Click_1(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void btn_Leave(object sender, EventArgs e)
        {

        }

        private void btn_Enter(object sender, EventArgs e)
        {

        }
    }
}
