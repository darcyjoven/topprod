/*
================================================================================
檔案代號:hrbr_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbr_file
(
hrbr01      varchar2(20) NOT NULL,   /*银行编码                               */
hrbr02      varchar2(50),            /*银行名称                               */
hrbr03      varchar2(50),            /*银行简称                               */
hrbr04      varchar2(20),            /*地区代码                               */
hrbr05      varchar2(20),            /*银行级别                               */
hrbr06      varchar2(50),            /*联系人                                 */
hrbr07      varchar2(20),            /*联系电话                               */
hrbr08      varchar2(20),            /*手机号码                               */
hrbr09      varchar2(20),            /*传真号码                               */
hrbr10      varchar2(50),            /*E-MAIL                                 */
hrbr11      varchar2(20),            /*邮政编码                               */
hrbr12      varchar2(255),           /*银行地址                               */
hrbr13      varchar2(20),            /*是否集团级                             */
hrbr14      varchar2(20),            /*所属公司编码                           */
hrbr15      varchar2(255),           /*备注                                   */
hrbracti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbruser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbrgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbrmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbrdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbroriu    varchar2(10),            /*资料建立者                             */
hrbrorig    varchar2(10),            /*资料建立部门                           */
hrbrud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbrud02    varchar2(40),            /*自订栏位-文字                          */
hrbrud03    varchar2(40),            /*自订栏位-文字                          */
hrbrud04    varchar2(40),            /*自订栏位-文字                          */
hrbrud05    varchar2(40),            /*自订栏位-文字                          */
hrbrud06    varchar2(40),            /*自订栏位-文字                          */
hrbrud07    number(15,3),            /*自订栏位-数值                          */
hrbrud08    number(15,3),            /*自订栏位-数值                          */
hrbrud09    number(15,3),            /*自订栏位-数值                          */
hrbrud10    number(10),              /*自订栏位-整数                          */
hrbrud11    number(10),              /*自订栏位-整数                          */
hrbrud12    number(10),              /*自订栏位-整数                          */
hrbrud13    date,                    /*自订栏位-日期                          */
hrbrud14    date,                    /*自订栏位-日期                          */
hrbrud15    date                     /*自订栏位-日期                          */
);

alter table hrbr_file add  constraint tpc_hrbr_pk primary key  (hrbr01) enable validate;
grant select on hrbr_file to tiptopgp;
grant update on hrbr_file to tiptopgp;
grant delete on hrbr_file to tiptopgp;
grant insert on hrbr_file to tiptopgp;
grant index on hrbr_file to public;
grant select on hrbr_file to ods;
