/*
================================================================================
檔案代號:hrbda_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbda_file
(
hrbda01     varchar2(20) NOT NULL,   /*争议单号                               */
hrbda02     number(5) NOT NULL,      /*项次                                   */
hrbda03     varchar2(20),            /*处理类型                               */
hrbda04     date,                    /*开始日期                               */
hrbda05     date,                    /*结束日期                               */
hrbda06     varchar2(100),           /*处理结果                               */
hrbdaacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbdauser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbdagrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbdamodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbdadate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbdaoriu   varchar2(10),            /*资料建立者                             */
hrbdaorig   varchar2(10)             /*资料建立部门                           */
);

alter table hrbda_file add  constraint tpc_hrbda_pk primary key  (hrbda01,hrbda02) enable validate;
grant select on hrbda_file to tiptopgp;
grant update on hrbda_file to tiptopgp;
grant delete on hrbda_file to tiptopgp;
grant insert on hrbda_file to tiptopgp;
grant index on hrbda_file to public;
grant select on hrbda_file to ods;
