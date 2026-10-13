/*
================================================================================
檔案代號:hrbc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbc_file
(
hrbc00      varchar2(20) NOT NULL,   /*流水号                                 */
hrbc01      varchar2(20),            /*员工ID                                 */
hrbc02      varchar2(20),            /*证件类型ID                             */
hrbc03      varchar2(20),            /*证件号码                               */
hrbc04      varchar2(100),           /* 发证机构                              */
hrbc05      date,                    /*生效日期                               */
hrbc06      date,                    /*失效日期                               */
hrbc07      date,                    /*培训开始日期                           */
hrbc08      date,                    /*培训结束日期                           */
hrbc09      varchar2(100),           /*培训机构                               */
hrbc10      varchar2(1),             /*是否年审                               */
hrbc11      date,                    /*下次年审日期                           */
hrbc12      varchar2(100),           /*备注                                   */
hrbcacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbcuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbcgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbcmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbcdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbcoriu    varchar2(10),            /*资料建立者                             */
hrbcorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrbc_file add  constraint tpc_hrbc_pk primary key  (hrbc00) enable validate;
grant select on hrbc_file to tiptopgp;
grant update on hrbc_file to tiptopgp;
grant delete on hrbc_file to tiptopgp;
grant insert on hrbc_file to tiptopgp;
grant index on hrbc_file to public;
grant select on hrbc_file to ods;
