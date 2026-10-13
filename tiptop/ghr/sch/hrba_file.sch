/*
================================================================================
檔案代號:hrba_file
檔案名稱:奖惩项目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrba_file
(
hrba01      varchar2(20) NOT NULL,   /*奖惩编码                               */
hrba02      varchar2(20),            /*奖惩名称                               */
hrba03      varchar2(20),            /*奖惩类型编码                           */
hrba04      varchar2(20),            /*公司编码                               */
hrba05      varchar2(100),           /*备注                                   */
hrbaacti    varchar2(1),             /*有效                                   */
hrbauser    varchar2(10),            /*资料所有者                             */
hrbagrup    varchar2(10),            /*资料所有群                             */
hrbamodu    varchar2(10),            /*资料修改者                             */
hrbadate    date,                    /*修改日期                               */
hrbaoriu    varchar2(10),            /*资料建立者                             */
hrbaorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrba_file add  constraint tpc_hrba_pk primary key  (hrba01) enable validate;
grant select on hrba_file to tiptopgp;
grant update on hrba_file to tiptopgp;
grant delete on hrba_file to tiptopgp;
grant insert on hrba_file to tiptopgp;
grant index on hrba_file to public;
grant select on hrba_file to ods;
