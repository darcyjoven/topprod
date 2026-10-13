/*
================================================================================
檔案代號:hrbj_file
檔案名稱:人员黑名单
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbj_file
(
hrbj01      varchar2(20) NOT NULL,   /*黑名单编号                             */
hrbj02      varchar2(10),            /*员工ID                                 */
hrbj03      varchar2(50),            /*姓名                                   */
hrbj04      varchar2(10),            /*证件类型                               */
hrbj05      varchar2(50),            /*证件号码                               */
hrbj06      date,                    /*出生日期                               */
hrbj07      varchar2(10),            /*性别                                   */
hrbj08      varchar2(10),            /*民族                                   */
hrbj09      varchar2(10),            /*婚姻状态                               */
hrbj10      varchar2(50),            /*籍贯                                   */
hrbj11      varchar2(255),           /*户口所在地                             */
hrbj12      varchar2(255),           /*现居住地                               */
hrbj13      varchar2(20),            /*联系电话                               */
hrbj14      varchar2(50),            /*邮件                                   */
hrbj15      varchar2(10),            /*学历                                   */
hrbj16      varchar2(50),            /*专业                                   */
hrbjacti    varchar2(1),             /*资料有效否                             */
hrbjud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbjud02    varchar2(40),            /*自订栏位-文字                          */
hrbjud03    varchar2(40),            /*自订栏位-文字                          */
hrbjud04    varchar2(40),            /*自订栏位-文字                          */
hrbjud05    varchar2(40),            /*自订栏位-文字                          */
hrbjud06    varchar2(40),            /*自订栏位-文字                          */
hrbjud07    number(15,3),            /*自订栏位-数值                          */
hrbjud08    number(15,3),            /*自订栏位-数值                          */
hrbjud09    number(15,3),            /*自订栏位-数值                          */
hrbjud10    number(10),              /*自订栏位-整数                          */
hrbjud11    number(10),              /*自订栏位-整数                          */
hrbjud12    number(10),              /*自订栏位-整数                          */
hrbjud13    date,                    /*自订栏位-日期                          */
hrbjud14    date,                    /*自订栏位-日期                          */
hrbjud15    date,                    /*自订栏位-日期                          */
                                     /*q                                      */
hrbjuser    varchar2(10),            /*资料所有者                             */
hrbjgrup    varchar2(10),            /*资料所有群                             */
hrbjmodu    varchar2(10),            /*资料更改者                             */
hrbjdate    date,                    /*最近修改日                             */
hrbjoriu    varchar2(10),            /*资料建立者                             */
hrbjorig    varchar2(10),            /*资料建立部门                           */
hrbj17      date,                    /*发生日期                               */
hrbj18      varchar2(4000)           /*备注                                   */
);

alter table hrbj_file add  constraint tpc_hrbj_pk primary key  (hrbj01) enable validate;
grant select on hrbj_file to tiptopgp;
grant update on hrbj_file to tiptopgp;
grant delete on hrbj_file to tiptopgp;
grant insert on hrbj_file to tiptopgp;
grant index on hrbj_file to public;
grant select on hrbj_file to ods;
