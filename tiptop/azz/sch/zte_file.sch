/*
================================================================================
檔案代號:zte_file
檔案名稱:档案名称单身档其他设定
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zte_file
(
zte01       varchar2(20) NOT NULL,   /*档案编号                               */
zte02       varchar2(20) NOT NULL,   /*数据库名称                             */
zte03       varchar2(30) NOT NULL,   /*字段代码                               */
zte04       varchar2(1),             /*属性                                   */
zte05       varchar2(1),             /*记录缺省值设置方式                     */
zte06       varchar2(255)            /*记录缺省值或程序代码                   */
);

alter table zte_file add  constraint zte_pk primary key  (zte01,zte02,zte03) enable validate;
grant select on zte_file to tiptopgp;
grant update on zte_file to tiptopgp;
grant delete on zte_file to tiptopgp;
grant insert on zte_file to tiptopgp;
grant index on zte_file to public;
grant select on zte_file to ods;
