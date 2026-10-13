/*
================================================================================
檔案代號:rtw_file
檔案名稱:采购协议调整单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtw_file
(
rtw01       varchar2(20) DEFAULT ' ' NOT NULL, /*协议调整单号*/
rtw02       varchar2(10) DEFAULT ' ' NOT NULL, /*调整營運中心*/
rtw03       varchar2(20),            /*协议编号                               */
rtw04       number(5),               /*协议版本号                             */
rtw05       varchar2(20),            /*合同编号                               */
rtw06       varchar2(10),            /*供应商代码                             */
rtw07       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rtw08       date,                    /*生效日期                               */
rtw09       date,                    /*终止日期                               */
rtw10       date,                    /*签订日期                               */
rtw11       date,                    /*废止日期                               */
rtw12       number(5,2),             /*预调价比例%                            */
rtw13       number(5,2),             /*预调结算扣率%                          */
rtw14       varchar2(10),            /*调整人（供应商）                       */
rtw15       varchar2(10),            /*调整人（内部）                         */
rtw16       varchar2(255),           /*备注                                   */
rtw900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rtwacti     varchar2(1),             /*资料有效码                             */
rtwcond     date,                    /*审核日期                               */
rtwconf     varchar2(1),             /*审核码                                 */
rtwconu     varchar2(10),            /*审核人员                               */
rtwcrat     date,                    /*资料创建日                             */
rtwdate     date,                    /*最近更改日                             */
rtwdays     number(5),               /*签核完成天数                           */
rtwgrup     varchar2(10),            /*资料所有部门                           */
rtwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtwmksg     varchar2(1),             /*是否签核                               */
rtwmodu     varchar2(10),            /*资料更改者                             */
rtwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rtwprit     number(5),               /*签核优先等级                           */
rtwsign     varchar2(4),             /*签核等级                               */
rtwsmax     number(5),               /*应签核顺序                             */
rtwsseq     number(5),               /*已签核顺序                             */
rtwuser     varchar2(10),            /*资料所有者                             */
rtworiu     varchar2(10),            /*资料建立者                             */
rtworig     varchar2(10),            /*资料建立部门                           */
rtw17       date,                    /*協議生效日期                           */
rtw18       date                     /*協議終止日期                           */
);

alter table rtw_file add  constraint rtw_pk primary key  (rtw01,rtw02) enable validate;
grant select on rtw_file to tiptopgp;
grant update on rtw_file to tiptopgp;
grant delete on rtw_file to tiptopgp;
grant insert on rtw_file to tiptopgp;
grant index on rtw_file to public;
grant select on rtw_file to ods;
