/*
================================================================================
檔案代號:hrdr_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdr_file
(
hrdr01      varchar2(10) NOT NULL,   /*流水码                                 */
hrdr02      varchar2(20),            /*工号ID                                 */
hrdr03      varchar2(20),            /*薪资年度                               */
hrdr04      varchar2(20),            /*月度                                   */
hrdr05      number(5),               /*发薪次数                               */
hrdr06      varchar2(20),            /*浮动参数                               */
hrdr07      number(15,2),            /*参数值                                 */
hrdr08      varchar2(255),           /*备注                                   */
hrdracti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdruser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdrgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdrmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdrdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdroriu    varchar2(10),            /*资料建立者                             */
hrdrorig    varchar2(10),            /*资料建立部门                           */
hrdrud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdrud02    varchar2(40),            /*自订栏位-文字                          */
hrdrud03    varchar2(40),            /*自订栏位-文字                          */
hrdrud04    varchar2(40),            /*自订栏位-文字                          */
hrdrud05    varchar2(40),            /*自订栏位-文字                          */
hrdrud06    varchar2(40),            /*自订栏位-文字                          */
hrdrud07    number(15,3),            /*自订栏位-数值                          */
hrdrud08    number(15,3),            /*自订栏位-数值                          */
hrdrud09    number(15,3),            /*自订栏位-数值                          */
hrdrud10    number(10),              /*自订栏位-整数                          */
hrdrud11    number(10),              /*自订栏位-整数                          */
hrdrud12    number(10),              /*自订栏位-整数                          */
hrdrud13    date,                    /*自订栏位-日期                          */
hrdrud14    date,                    /*自订栏位-日期                          */
hrdrud15    date                     /*自订栏位-日期                          */
);

alter table hrdr_file add  constraint tpc_hrdr_pk primary key  (hrdr01) enable validate;
grant select on hrdr_file to tiptopgp;
grant update on hrdr_file to tiptopgp;
grant delete on hrdr_file to tiptopgp;
grant insert on hrdr_file to tiptopgp;
grant index on hrdr_file to public;
grant select on hrdr_file to ods;
