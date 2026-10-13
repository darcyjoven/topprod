/*
================================================================================
檔案代號:hrdn_file
檔案名稱:员工银行帐号维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdn_file
(
hrdn01      varchar2(10) NOT NULL,   /*流水码                                 */
hrdn02      varchar2(20),            /*员工ID                                 */
hrdn03      varchar2(20),            /*转账银行                               */
hrdn04      varchar2(20),            /*开户银行                               */
hrdn05      varchar2(50),            /*账号                                   */
hrdn06      varchar2(20),            /*设置人ID                               */
hrdn07      date,                    /*设置日期                               */
hrdn08      varchar2(20),            /*账号性质                               */
hrdn09      varchar2(50),            /*开始薪资月                             */
hrdn10      varchar2(50),            /*失效薪资月                             */
hrdn11      varchar2(1),             /*是否合用                               */
hrdn12      varchar2(255),           /*备注                                   */
hrdnacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdnuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdngrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdnmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdndate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdnoriu    varchar2(10),            /*资料建立者                             */
hrdnorig    varchar2(10),            /*资料建立部门                           */
hrdnud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdnud02    varchar2(40),            /*自订栏位-文字                          */
hrdnud03    varchar2(40),            /*自订栏位-文字                          */
hrdnud04    varchar2(40),            /*自订栏位-文字                          */
hrdnud05    varchar2(40),            /*自订栏位-文字                          */
hrdnud06    varchar2(40),            /*自订栏位-文字                          */
hrdnud07    number(15,3),            /*自订栏位-数值                          */
hrdnud08    number(15,3),            /*自订栏位-数值                          */
hrdnud09    number(15,3),            /*自订栏位-数值                          */
hrdnud10    number(10),              /*自订栏位-整数                          */
hrdnud11    number(10),              /*自订栏位-整数                          */
hrdnud12    number(10),              /*自订栏位-整数                          */
hrdnud13    date,                    /*自订栏位-日期                          */
hrdnud14    date,                    /*自订栏位-日期                          */
hrdnud15    date,                    /*自订栏位-日期                          */
hrdn13      varchar2(1)              /*是否无限期                             */
);

alter table hrdn_file add  constraint tpc_hrdn_pk primary key  (hrdn01) enable validate;
grant select on hrdn_file to tiptopgp;
grant update on hrdn_file to tiptopgp;
grant delete on hrdn_file to tiptopgp;
grant insert on hrdn_file to tiptopgp;
grant index on hrdn_file to public;
grant select on hrdn_file to ods;
