/*
================================================================================
檔案代號:obc_file
檔案名稱:集团间销售预测单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table obc_file
(
obc01       varchar2(40) NOT NULL,   /*料件编号                               */
obc02       varchar2(1) NOT NULL,    /*计划期别格式                           */
obc021      number(10) NOT NULL,     /*起始期别                               */
obc03       number(5),               /*生成期数                               */
obc04       varchar2(10),            /*计划员                                 */
obc05       varchar2(10),            /*部门                                   */
obc06       varchar2(1),             /*撷取否                                 */
obc07       varchar2(4),             /*库存单位                               */
obc08       varchar2(1),             /*No                                     */
obc09       varchar2(1),             /*No                                     */
obcconf     varchar2(1),             /*计划审核                               */
obcacti     varchar2(1),             /*资料有效码                             */
obcuser     varchar2(10),            /*资料所有者                             */
obcgrup     varchar2(10),            /*资料所有群                             */
obcmodu     varchar2(10),            /*资料更改者                             */
obcdate     date,                    /*最近更改日                             */
obcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
obclegal    varchar2(10) NOT NULL,   /*所属法人                               */
obcorig     varchar2(10),            /*资料建立部门                           */
obcoriu     varchar2(10)             /*资料建立者                             */
);

alter table obc_file add  constraint obc_pk primary key  (obc01,obc02,obc021) enable validate;
grant select on obc_file to tiptopgp;
grant update on obc_file to tiptopgp;
grant delete on obc_file to tiptopgp;
grant insert on obc_file to tiptopgp;
grant index on obc_file to public;
grant select on obc_file to ods;
