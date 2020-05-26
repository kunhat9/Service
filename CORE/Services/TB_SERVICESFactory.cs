using CORE.Internal;
using CORE.Internal.View;
using CORE.Tables;
using CORE.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CORE.Services
{
    public class TB_SERVICESFactory
    {
        public bool Insert(TB_SERVICES blog)
        {
            return new TB_SERVICESSql().Insert(blog);
        }
        public bool Update(TB_SERVICES blog)
        {
            return new TB_SERVICESSql().Update(blog);
        }
        public string InsertOrUpdate(TB_SERVICES service, List<TB_SERVICE_DETAILS> details)
        {
            string ecode = "";
            string edesc = "";
            string serviceXml = service.ToStringXml();
            string xmlService = "<row>" + serviceXml + "</row>";
            string infoXml = "";
            foreach (var item in details)
            {
                infoXml += "<row>" + item.ToStringXml() + "</row>";
            }
            string xmlInfo = "<row>" + infoXml + "</row>";
            TB_SERVICESSql sql = new TB_SERVICESSql();
            sql.SelectFromStore(out ecode, out edesc, AppSettingKeys.SP_INSERT_OR_UPDATE_TYPES, xmlService, xmlInfo);
            return ecode;
        }
        public TB_SERVICES GetById(int serviceId)
        {
            return new TB_SERVICESSql().SelectByPrimaryKey(serviceId);
        }
        public List<TB_SERVICES> GetAll()
        {
            return new TB_SERVICESSql().SelectAll();
        }
        public List<V_Details_Service> GetAllBy(string keyText, string unit, string orgId, int pageNumber, int pageSize, out int count)
        {
            List<V_Details_Service> list = new List<V_Details_Service>();
            object cTemp;
            list = new V_Details_ServiceSql().SelectFromStoreOutParam(AppSettingKeys.SP_SERVICE_GET_ALL_BY, out cTemp, keyText, unit, orgId, pageNumber, pageSize);
            count = (int)cTemp;
            return list;
        }
    }
}
