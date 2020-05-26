﻿using CORE.Internal;
using CORE.Tables;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CORE.Services
{
    public class TB_FILESFactory
    {
        public int Insert(TB_FILES files)
        {
            int result = 0;
            TB_FILESSql sql = new TB_FILESSql();
            string data = sql.InsertReturnId(files);
            if (!string.IsNullOrEmpty(data))
            {
                result = Int32.Parse(data);
            }
            else
            {
                result = -1;
            }
            return result;
        }
        public bool DeleteFile(int fileId, string filePath)
        {

            TB_FILES file = new TB_FILES();
            file = new TB_FILESSql().SelectByPrimaryKey(fileId);
            TB_FILESSql sql = new TB_FILESSql();
            string url = filePath + file.FilePath;

            if (sql.Delete(fileId))
            {
                File.Delete(url);
                return true;
            }
            else
            {
                return false;
            }

        }
        public List<TB_FILES> GetAll()
        {
            return new TB_FILESSql().SelectAll();
        }
        public List<TB_FILES> GetByRefecense(int id)
        {
            return new TB_FILESSql().FilterByField(TB_FILES.TB_FILES_Field.FileReferenceId.ToString(), id);
        }
        public bool Update(TB_FILES files)
        {
            return new TB_FILESSql().Update(files);
        }
    }
}
