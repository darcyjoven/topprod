/*
================================================================================
檔案代號:hraq_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraq_file
(
hraq01      number(5),               /*项次                                   */
hraq02      varchar2(100) NOT NULL,  /*名称                                   */
hraq03      varchar2(1000),          /*详细描述                               */
hraqacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hraquser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hraqgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hraqmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hraqdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraqoriu    varchar2(10),            /*资料建立者                             */
hraqorig    varchar2(10)             /*资料建立部门                           */
);

alter table hraq_file add  constraint tpc_hraq_pk primary key  (hraq02) enable validate;
grant select on hraq_file to tiptopgp;
grant update on hraq_file to tiptopgp;
grant delete on hraq_file to tiptopgp;
grant insert on hraq_file to tiptopgp;
grant index on hraq_file to public;
grant select on hraq_file to ods;
