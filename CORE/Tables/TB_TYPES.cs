using CORE.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CORE.Tables
{
    public class TB_TYPES : BusinessObject
    {
        [PrimaryKey]
        public string TypeCode { get; set; }
        public string TypeName { get; set; }
    }
}
