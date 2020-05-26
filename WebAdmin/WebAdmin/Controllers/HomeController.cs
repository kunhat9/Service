using CORE.Tables;
using CORE.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using WebAdmin.AppSession;
using WebAdmin.Cookie;

namespace WebAdmin.Controllers
{
    public class HomeController : BaseController
    {
        #region Login

        public ActionResult Login(string url)
        {
            ViewBag.url = url;
            if (Session[AppSessionKeys.USER_INFO] != null)
            {
                if (string.IsNullOrEmpty(url))
                {
                    return RedirectToAction("Index");
                }
                else
                {
                    return RedirectPermanent(url);
                }
            }
            else
            {
                ViewBag.username = AppCookieInfo.UserID;
                ViewBag.password = AppCookieInfo.HashedPassword;

                return View();
            }
        }

        [HttpPost]
        public ActionResult Login(string username, string password, string url, string remember)
        {
            ViewBag.url = url;

            if (Session[AppSessionKeys.USER_INFO] == null)
            {
                if (string.IsNullOrEmpty(username))
                {
                    ViewBag.error = "Chưa nhập Tên đăng nhập";
                    return View();
                }
                if (string.IsNullOrEmpty(password))
                {
                    ViewBag.error = "Chưa nhập Mật khẩu";
                    return View();
                }
                string newPass = GetMD5Hash(password); // pass MD5 

                VIEW_INFO_USER_LOGIN user = Users_Service.CheckLogin(username, password);
                if (user == null)
                {
                    ViewBag.error = "Đăng nhập sai hoặc bạn không có quyền vào";
                    return View();
                }
                else
                {
                    Session[AppSessionKeys.USER_INFO] = user;
                    if (remember == "on")
                    {
                        AppCookieInfo.UserID = username;
                        AppCookieInfo.HashedPassword = password;
                    }
                    else
                    {
                        AppCookieInfo.RemoveAllCookies();
                    }
                    //OK
                }
            }

            if (string.IsNullOrEmpty(url))
            {
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectPermanent(url);
            }
        }

        public ActionResult Logout()
        {
            Session.Clear();

            return RedirectToAction("Index");
        }

        #endregion

        #region OutLogin

        public ActionResult Index()
        {
            string now = DateTime.Now.ToString("yyyy-MM-dd");

            DateTime monthStart = DateTime.Today.AddDays(1 - DateTime.Today.Day);

            try
            {
                //string boxId = ((VIEW_INFO_USER_LOGIN)Session[AppSession.AppSessionKeys.USER_INFO]).BOX_ID;
                //int count = 0;

                //List<SYS_USERS> listAllMember = SYS_USER_Service
                //    .GetAllByOutCount("", boxId, "", "", "MEMBER", 1, 5, out count);
                //ViewBag.totalMember = count;
                //ViewBag.MemberCurMonth = listAllMember;

                //List<GYM_VOUCHERS> listVoucherCurMonth = GYM_VOUCHERS_Service
                //    .GetAllByOutCount("", boxId, now, now, 1, 5, out count)
                //    .OrderByDescending(x => x.VOUCHER_BEGIN).ToList();
                //ViewBag.VoucherCurMonth = listVoucherCurMonth;

                //ViewBag.CostAvg = 0;
                //ViewBag.RevenueAvg = 0;
                //ViewBag.curMonth = monthStart.ToString("MM/yyyy");

                //List<GYM_CHART_PROFIT> listSpend = GYM_CHECKIN_Service.GetAllRevenueByYear(boxId, "", "");
                //ViewBag.listProfit = listSpend;
                //for (int i = 0; i < listSpend.Count; i++)
                //{
                //    if (listSpend[i].sMonth == monthStart.Month)
                //    {
                //        ViewBag.CostCurMonth = listSpend[i].Cost;
                //        ViewBag.RevenueCurMonth = listSpend[i].Revenue;
                //    }
                //    ViewBag.CostAvg += listSpend[i].Cost;
                //    ViewBag.RevenueAvg += listSpend[i].Revenue;
                //}
                //ViewBag.CostAvg = Math.Round(ViewBag.CostAvg / listSpend.Count, 2);
                //ViewBag.RevenueAvg = Math.Round(ViewBag.RevenueAvg / listSpend.Count, 2);
                //ViewBag.ProfitAvg = Math.Round(ViewBag.RevenueAvg - ViewBag.CostAvg, 2);
                //ViewBag.ProfitCurMonth = ViewBag.RevenueCurMonth - ViewBag.CostCurMonth;
            }
            catch (Exception ex)
            {
                CORE.Helpers.IOHelper.WriteLog(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ADM"), GetIP(), ex.ToString());
            }

            return View();
        }

        [ChildActionOnly]
        public PartialViewResult _HomeHeader()
        {
            ViewBag.userName = "Dịch vụ";
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult _HomeFooter()
        {
            return PartialView();
        }

        [ChildActionOnly]
        public PartialViewResult _HomeMenuLeft()
        {
            ViewBag.boxName = "Dịch vụ";
            ViewBag.fullName = "Đồ án";
            List<SYS_ACTIONS> actions = new List<SYS_ACTIONS>
            {
                new SYS_ACTIONS { Id = "0", Name = "Trang chủ", IsModule = false, IsRoot = true, IsShow = true, ControlPath = "/" }

                , new SYS_ACTIONS { Id = "1", Name = "Quản lý dịch vụ", IsModule = true, IsRoot = true, IsShow = true }
                , new SYS_ACTIONS { Id = "2", Name = "Danh sách Loại dịch vụ", IsModule = false, IsRoot = false, IsShow = true, ControlPath = "/Services/TypeList", ParentId = "1" }
                , new SYS_ACTIONS { Id = "3", Name = "Danh sách dịch vụ", IsModule = false, IsRoot = false, IsShow = true, ControlPath = "/Services/Index", ParentId = "1" }

                , new SYS_ACTIONS { Id = "21", Name = "Quản lý bài viết", IsModule = true, IsRoot = true, IsShow = true }
                , new SYS_ACTIONS { Id = "22", Name = "Danh sách bài viết", IsModule = false, IsRoot = false, IsShow = true, ControlPath = "/Blogs/Index", ParentId = "21" }
            };
            return PartialView(actions);
        }

        [ChildActionOnly]
        public PartialViewResult _Pagination(int maxNumber, int pageNumber)
        {
            ViewBag.maxNumber = maxNumber;
            ViewBag.pageNumber = pageNumber;
            return PartialView();
        }

        #endregion

        public ActionResult NotPermission()
        {
            return View();
        }

        public PartialViewResult _NotPermission()
        {
            return PartialView();
        }
    }
}