/*
================================================================================
檔案代號:sfp_file
檔案名稱:工单发料底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfp_file
(
sfp01       varchar2(20) NOT NULL,   /*发料单号                               */
                                     /*發料單號                               */
sfp02       date,                    /*录入日期                               */
                                     /*輸入日期                               */
sfp03       date,                    /*扣帐日期                               */
                                     /*扣帳日期                               */
sfp04       varchar2(1),             /*扣帐码                                 */
                                     /*扣帳碼(Y/N)                            */
sfp05       varchar2(1),             /*打印码                                 */
                                     /*列印碼(Y/N)                            */
sfp06       varchar2(1),             /*异动类型                               */
                                     /*Transaction Type 1.DSet Issue 2.Over-Withdraw 3.Covering 4.Consumable Withdrawal 6.Set Returns 8.General Return 9.Consumable Material Returned A.Re. Production Material Issuing B.Re. Production Returns C.Re. Production Withdrawal*/
sfp07       varchar2(10),            /*制造部门                               */
                                     /*製造部門  gem01                        */
sfp08       varchar2(20),            /*料表批号                               */
                                     /*料表批號  sfc01                        */
sfp09       varchar2(1),             /*挪料否                                 */
                                     /*挪料否        #NO:6968                 */
                                     /*紀錄是否為挪料資料產生的發/退料資料    */
sfp10       varchar2(8),             /*序号                                   */
                                     /*序號          #NO:6968                 */
                                     /*當此筆發退料單為工單挪料作業自動產生並 */
                                     /*扣帳時，此欄位記錄挪料紀錄檔的序號     */
                                     /*當此張發退料單做過帳還原時，可以此序號　*/
                                     /*串工單挪料紀錄檔(sfm_file,sfn_fil)刪除　*/
                                     /*挪料紀錄                               */
sfpuser     varchar2(10),            /*资料所有者                             */
sfpgrup     varchar2(10),            /*资料所有部门                           */
sfpmodu     varchar2(10),            /*资料更改者                             */
sfpdate     date,                    /*最近更改日                             */
sfp11       varchar2(10) DEFAULT ' ',/*理由码                                 */
sfpconf     varchar2(1),             /*确认码                                 */
sfpud01     varchar2(255),           /*原因                                   */
sfpud02     varchar2(40),            /*投产批次号                             */
sfpud03     varchar2(40),            /*申请单号                               */
sfpud04     varchar2(40),            /*完工单号                               */
sfpud05     varchar2(255),           /*解决办法                               */
sfpud06     varchar2(40),            /*自订字段-文字                          */
sfpud07     number(15,3),            /*自订字段-数值                          */
sfpud08     number(15,3),            /*自订字段-数值                          */
sfpud09     number(15,3),            /*自订字段-数值                          */
sfpud10     number(10),              /*自订字段-整数                          */
sfpud11     number(10),              /*自订字段-整数                          */
sfpud12     number(10),              /*自订字段-整数                          */
sfpud13     date,                    /*自订字段-日期                          */
sfpud14     date,                    /*自订字段-日期                          */
sfpud15     date,                    /*自订字段-日期                          */
sfp12       varchar2(20),            /*仓管员                                 */
sfp13       varchar2(1),             /*拆分发料否                             */
sfp14       varchar2(20),
sfpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfplegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfporiu     varchar2(10),            /*资料建立者                             */
sfporig     varchar2(10),            /*资料建立部门                           */
sfp15       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
sfp16       varchar2(10),            /*申请人                                 */
sfpmksg     varchar2(1) DEFAULT 'N' NOT NULL /*是否签核*/
);

alter table sfp_file add  constraint sfp_pk primary key  (sfp01) enable validate;
grant select on sfp_file to tiptopgp;
grant update on sfp_file to tiptopgp;
grant delete on sfp_file to tiptopgp;
grant insert on sfp_file to tiptopgp;
grant index on sfp_file to public;
grant select on sfp_file to ods;
