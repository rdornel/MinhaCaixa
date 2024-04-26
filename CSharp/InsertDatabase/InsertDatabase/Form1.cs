using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InsertDatabase
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        SqlConnection sqlConn = new SqlConnection("server=192.168.56.102;Database=MinhaCaixa;User id=alunos;Password=pass@word1");
        SqlCommand cmd;

        private void Form1_Load(object sender, EventArgs e)
        {


        }


        private void textBox1_TextChanged(object sender, EventArgs e)
        {
        }


        private void button1_Click(object sender, EventArgs e)
        {
            sqlConn.Open();
            string nome_texto = textBox1.Text;
            string sexo_texto = textBox2.Text;
            string cpf_texto = textBox3.Text;
            string sobrenome_texto = textBox4.Text;

            SqlCommand cmd = new SqlCommand("INSERT dbo.Clientes (ClienteNome, ClienteSobrenome, ClienteCPF, ClienteSexo ) VALUES  ('" + nome_texto + "', '" + sobrenome_texto + "', '" + cpf_texto + "', '" + sexo_texto + "')", sqlConn);
            cmd.ExecuteNonQuery();
            
            //ver
            //https://msdn.microsoft.com/pt-br/library/system.data.sqlclient.sqlcommand.prepare%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396 
             
            MessageBox.Show("Inserido Novo Registro Nome: "+nome_texto + " Sobrenome: " + sobrenome_texto.ToString()+ " Sexo: " +sexo_texto.ToString());
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

       }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
