/*
================================================================================
檔案代號:rtu_file
檔案名稱:促銷協議單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtu_file
(
rtu01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销协议编号*/
rtu02       varchar2(10) DEFAULT ' ' NOT NULL, /*签订营运中心*/
rtu03       varchar2(20),            /*文档编号                               */
rtu04       varchar2(20),            /*采购协议编号                           */
rtu05       varchar2(10),            /*供应商代码                             */
rtu06       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rtu07       varchar2(1),             /*促销哦类型                             */
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price 6.Full Amount Promotion 9.Rebate Promotion*/
rtu08       varchar2(20),            /*促销单号                               */
rtu09       date,                    /*生效日期                               */
rtu10       date,                    /*终止日期                               */
rtu11       date,                    /*废止日期                               */
rtu12       number(5,2),             /*预设促销折扣比例%                      */
rtu13       number(5,2),             /*预设促销分摊比例%                      */
rtu14       varchar2(10),            /*签订人（供应商）                       */
rtu15       varchar2(10),            /*签订人（内部）                         */
rtu16       varchar2(255),           /*备注                                   */
rtu17       varchar2(4),             /*税种                                   */
rtu18       number(9,4),             /*税率                                   */
rtu900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rtuacti     varchar2(1),             /*资料有效码                             */
rtucond     date,                    /*审核日期                               */
rtuconf     varchar2(1),             /*审核码                                 */
rtuconu     varchar2(10),            /*审核人员                               */
rtucrat     date,                    /*资料创建日                             */
rtudate     date,                    /*最近更改者                             */
rtudays     number(5),               /*签核完成天数                           */
rtugrup     varchar2(10),            /*资料所有部门                           */
rtulegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtumksg     varchar2(1),             /*是否签核                               */
rtumodu     varchar2(10),            /*资料更改者                             */
rtuplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rtuprit     number(5),               /*签核优先等级                           */
rtusign     varchar2(4),             /*签核等级                               */
rtusmax     number(5),               /*应签核顺序                             */
rtusseq     number(5),               /*已签核顺序                             */
rtuuser     varchar2(10),            /*资料所有者                             */
rtuorig     varchar2(10),            /*资料建立部门                           */
rtuoriu     varchar2(10)             /*资料建立者                             */
);

alter table rtu_file add  constraint rtu_pk primary key  (rtu01,rtu02,rtuplant) enable validate;
grant select on rtu_file to tiptopgp;
grant update on rtu_file to tiptopgp;
grant delete on rtu_file to tiptopgp;
grant insert on rtu_file to tiptopgp;
grant index on rtu_file to public;
grant select on rtu_file to ods;
