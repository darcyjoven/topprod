/*
================================================================================
檔案代號:sha_file
檔案名稱:工单Check in 维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sha_file
(
sha01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
sha02       number(5) NOT NULL,      /*工艺序号                               */
                                     /*製程序號                               */
sha03       varchar2(10),            /*班别                                   */
                                     /*班別                                   */
sha04       date NOT NULL,           /*日期                                   */
sha041      varchar2(8) NOT NULL,    /*时间                                   */
                                     /*時間                                   */
sha05       number(15,3),            /*Check in 数量                          */
                                     /*Check in 數量                          */
sha06       varchar2(10),            /*员工编号                               */
                                     /*員工編號                               */
sha07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
sha08       varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
sha09       varchar2(1),             /*No Use                                 */
sha10       varchar2(1),             /*No Use                                 */
shaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
shauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
shagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
shamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
shadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
shaud01     varchar2(255),           /*自订字段-Textedit                      */
shaud02     varchar2(40),            /*自订字段-文字                          */
shaud03     varchar2(40),            /*自订字段-文字                          */
shaud04     varchar2(40),            /*自订字段-文字                          */
shaud05     varchar2(40),            /*自订字段-文字                          */
shaud06     varchar2(40),            /*自订字段-文字                          */
shaud07     number(15,3),            /*自订字段-数值                          */
shaud08     number(15,3),            /*自订字段-数值                          */
shaud09     number(15,3),            /*自订字段-数值                          */
shaud10     number(10),              /*自订字段-整数                          */
shaud11     number(10),              /*自订字段-整数                          */
shaud12     number(10),              /*自订字段-整数                          */
shaud13     date,                    /*自订字段-日期                          */
shaud14     date,                    /*自订字段-日期                          */
shaud15     date,                    /*自订字段-日期                          */
shaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shalegal    varchar2(10) NOT NULL,   /*所属法人                               */
shaoriu     varchar2(10),            /*资料建立者                             */
shaorig     varchar2(10),            /*资料建立部门                           */
sha012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sha_file add  constraint sha_pk primary key  (sha01,sha02,sha04,sha041,sha08,sha012) enable validate;
grant select on sha_file to tiptopgp;
grant update on sha_file to tiptopgp;
grant delete on sha_file to tiptopgp;
grant insert on sha_file to tiptopgp;
grant index on sha_file to public;
grant select on sha_file to ods;
