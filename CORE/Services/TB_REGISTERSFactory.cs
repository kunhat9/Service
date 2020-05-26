using CORE.Internal;
using CORE.Tables;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CORE.Services
{
    public class TB_REGISTERSFactory
    {
        public bool Insert(TB_REGISTERS register)
        {
            return new TB_REGISTERSSql().Insert(register);
        }
        public bool Update(TB_REGISTERS register)
        {
            return new TB_REGISTERSSql().Update(register);
        }
        public List<TB_REGISTERS> GetAllBy(string keyText, string startDate , string endDate, string total , string serviceId, string status , int pageNumber, int pageSize , out int count)
        {
            List<TB_REGISTERS> list = new List<TB_REGISTERS>();
            object cTemp;
            TB_REGISTERSSql sql = new TB_REGISTERSSql();
            list = sql.SelectFromStoreOutParam(AppSettingKeys.SP_REGISTER_GET_ALL_BY, out cTemp, keyText, startDate, endDate, total, serviceId, status, pageNumber, pageSize);
            count = (int)cTemp;
            return list;
        }
    }
}
