using CORE.Internal;
using CORE.Tables;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CORE.Views;
using CORE.Internal.View;

namespace CORE.Services
{
    public class TB_TYPESFactory
    {
        public bool Insert(TB_TYPES blog)
        {
            return new TB_TYPESSql().Insert(blog, true);
        }
        public bool Update(TB_TYPES blog)
        {
            return new TB_TYPESSql().Update(blog);
        }
        public string InsertOrUpdateType(TB_TYPES types , List<TB_TYPE_DETAILS> details)
        {
            string ecode = "";
            string edesc = "";
            string typeXml = types.ToStringXml();
            string xmlOrder = "<row>" + typeXml + "</row>";
            string infoXml = "";

            foreach (var item in details)
            {
                infoXml += "<row>" + item.ToStringXml() + "</row>";
            }
            string xmlInfo = "<row>" + infoXml + "</row>";
            TB_TYPESSql sql = new TB_TYPESSql();
            sql.SelectFromStore(out ecode, out edesc, AppSettingKeys.SP_INSERT_OR_UPDATE_TYPES, xmlOrder, xmlInfo);
            return ecode;
        }
        public TB_TYPES GetById(string typeId)
        {
            return new TB_TYPESSql().SelectByPrimaryKey(typeId);
        }
        public List<TB_TYPES> GetAll()
        {
            return new TB_TYPESSql().SelectAll();
        }
        public List<V_Details_Type> GetAllBy(string keyText, int pageNumber , int pageSize, out int count)
        {
            object cTemp;
            List<V_Details_Type> list = new List<V_Details_Type>();
            V_Details_TypeSql sql = new V_Details_TypeSql();
            list = sql.SelectFromStoreOutParam(AppSettingKeys.SP_TYPE_GET_ALL_BY, out cTemp, keyText, pageNumber, pageSize);
            count = (int)cTemp;
            return list;
        }
    }
}
