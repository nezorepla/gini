using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class _Default : System.Web.UI.Page
{
    Gcs cs = new Gcs();

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnE_Click(object sender, EventArgs e)
    {
        if (cs.SoruKaydet(Session["sezon"].ToString(), txtQID.Text.ToString(), "0.80") == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }
        }
    }
    protected void btnH_Click(object sender, EventArgs e)
    {
        if (cs.SoruKaydet(Session["sezon"].ToString(), txtQID.Text.ToString(), "0.20") == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }
        }
    }
    protected void btnB_Click(object sender, EventArgs e)
    {
        if (cs.SoruKaydet(Session["sezon"].ToString(), txtQID.Text.ToString(), "0") == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }
        }
    }
    protected void btnHE_Click(object sender, EventArgs e)
    {
        if (cs.SoruKaydet(Session["sezon"].ToString(), txtQID.Text.ToString(), "0.60") == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }
        }
    }
    protected void btnHH_Click(object sender, EventArgs e)
    {
        if (cs.SoruKaydet(Session["sezon"].ToString(), txtQID.Text.ToString(), "0.40") == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }
        }
    }
    protected void btnBasla_Click(object sender, EventArgs e)
    {
        Session["sezon"] = DateTime.Now.Ticks.ToString().Substring(5);
        if (cs.YeniSezon(Session["sezon"].ToString()) == "1")
        {
            String E = cs.ENTROPY(Session["sezon"].ToString());
            txtQID.Text = E;
            if (E == "EOF") { lblSoru.Text = ""; 
                LISTELE(); } else { lblSoru.Text = cs.SoruFromId(E); }

        }
    }

    private void LISTELE()
    {
        lblList.Text = "<hr>" + cs.ListItems(Session["sezon"].ToString());
    }

 
}
