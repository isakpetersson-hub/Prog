using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Evil_or_nice
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_evil_CheckedChanged(object sender, EventArgs e)
        {
            button_halsning.BackColor = Color.Red;
        }

        private void btn_halsning(object sender, EventArgs e)
        {
            Random Rng = new Random();
            string namn = textBoxNamn.Text;
            int numer = Rng.Next(4);
            if (radio_evil.Checked)
            {
                string[] evilhalsning = new string[] {namn + " är sämst", namn +" är dålig", "Hej " + namn + " du är inte bra"};
                switch (numer)
                {
                    case 1:
                        label_result.Text = evilhalsning[0];
                        break;
                    case 2:
                        label_result.Text = evilhalsning[1];
                        break;
                    case 3:
                        label_result.Text = evilhalsning[2];
                        break;
                }
            }
            else
            {
                string[] nicehalsning = new string[] { namn + " är bäst", namn + " är fantastisk", "Hej" + namn +"du kommer är jätte bra"};
                switch (numer)
                {
                    case 1:
                        label_result.Text = nicehalsning[0];
                        break;
                    case 2:
                        label_result.Text = nicehalsning[1];
                        break;
                    case 3:
                        label_result.Text = nicehalsning[2];
                        break;
                }
            }
        }

        private void btn_nice_CheckedChanged(object sender, EventArgs e)
        {
            button_halsning.BackColor = Color.Green;
        }
    }
}
