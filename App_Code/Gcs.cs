using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

/// <summary>
/// Summary description for Gcs
/// </summary>
public class Gcs
{
    public Gcs()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string ilkSoru()
    {
        string RV = "";

        string Sql;

        Sql = " DECLARE @A FLOAT; SELECT @A=COUNT(*) FROM PERSON_DIM_RESPONSE WHERE QID <> 0;   "
            + "   SELECT QID,B,@A A, CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END E"
            + " FROM( SELECT  QID,CONVERT(FLOAT,COUNT(*)) B"
            + " FROM PERSON_DIM_RESPONSE R1"
            + " WHERE QID <> 0"
            + " GROUP BY QID"
            + " ) AS X  GROUP BY QID,B"
            + " ORDER BY CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END DESC, QID ASC;";


        DataTable dt = PCL.MsSQL_DBOperations.GetData(Sql, "GN");

        //  RV=   ACL.Output.makeul(dt);
        //   Page.ClientScript.RegisterStartupScript(typeof(Page), "OrgChart", "var treeNodes =" + JSVAL, true);
        try
        {
            RV = SoruFromId(PCL.Utility.DBtoMT.ToString(dt.Rows[0]["QID"]));
            //foreach (DataRow dr in dt.Rows)
            //{
            //    RV += "<div id=\"AB_" + dr["AB_Id"].ToString() + "\" query=\"?I=1&AB=" + dr["AB_Id"].ToString() + "\" class=\"AB button big red\"> " + dr["AB_Text"].ToString() + "</div><div  id=\"_AB_" + dr["AB_Id"].ToString() + "\"></div>";
            //}
        }
        catch (Exception e) { RV = "<h3>hata @ilksoru: " + e + "</h3>"; }


        return RV;


    }
        public string ENTROPY(string S)
    {
        string RV = "";

        string Sql;

 

        DataTable dt = PCL.MsSQL_DBOperations.GetData("EXEC FB_SP_ENTROPY "+S, "GN");
      try
        {
            if (dt.Rows.Count > 0)
            {

                RV = PCL.Utility.DBtoMT.ToString(dt.Rows[0]["QID"]);
            }
            else { RV = "EOF"; }
        }
      catch (Exception e) { RV = "<h3>hata @Entropy: " + e + "</h3>"; }

        return RV;


    }
    
    public string SoruFromId(string QID)
    {
        string RV = "";

        string Sql;

        Sql = "  SELECT  [ID]      ,[QID]      ,[Q]      ,[TID]  FROM [DecisionTree].[dbo].[PERSON_DIM_QUESTION] where QID=" + QID;


        DataTable dt = PCL.MsSQL_DBOperations.GetData(Sql, "GN");

        //  RV=   ACL.Output.makeul(dt);
        //   Page.ClientScript.RegisterStartupScript(typeof(Page), "OrgChart", "var treeNodes =" + JSVAL, true);
        try
        {
            RV = PCL.Utility.DBtoMT.ToString(dt.Rows[0]["Q"]);
            //foreach (DataRow dr in dt.Rows)
            //{
            //    RV += "<div id=\"AB_" + dr["AB_Id"].ToString() + "\" query=\"?I=1&AB=" + dr["AB_Id"].ToString() + "\" class=\"AB button big red\"> " + dr["AB_Text"].ToString() + "</div><div  id=\"_AB_" + dr["AB_Id"].ToString() + "\"></div>";
            //}
        }
        catch(Exception e) { RV = "<h3>hata @SoruFromId: "+e+"</h3>"; }


        return RV;


    }

    public string YeniSezon(string s)
    {
        string RV = "1";
        try
        {
            PCL.MsSQL_DBOperations.ExecuteSQLStr("Exec FB_SP_SA '" + s + "','A25318'", "GN");
        }
        catch
        {
            RV = "0";
        }
        return RV;
    }
    public string SoruKaydet(string s, string q, string r)
    {
        string RV = "1";
        try
        {
            PCL.MsSQL_DBOperations.ExecuteSQLStr("Exec FB_SP_ANSWERS " + s + " ," + q + " ," + r, "GN");
        }
        catch //(Exception e) { RV = "<h3>hata: " + e + "</h3>"; }
        {
            RV = "0";
        }
        return RV;
    }

    public string ListItems(string s)
    {
        string RV = "";

        string Sql;

        Sql = "exec FB_SP_ListItem " + s;


        DataTable dt = PCL.MsSQL_DBOperations.GetData(Sql, "GN");

        //  RV=   ACL.Output.makeul(dt);
        //   Page.ClientScript.RegisterStartupScript(typeof(Page), "OrgChart", "var treeNodes =" + JSVAL, true);
        try
        {

            foreach (DataRow dr in dt.Rows)
            {
                RV += "<div>" + dr["NM"].ToString() + " " + dr["SURNM"].ToString() + "</div>";
            }
        }
        catch (Exception e) { RV = "<h3>hata @ListItems: " + e + "</h3>"; }


        return RV;
        
     
    }
}
