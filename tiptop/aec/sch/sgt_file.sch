/*
================================================================================
檔案代號:sgt_file
檔案名稱:工单工艺变更档
檔案目的:工单工艺变更单头档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgt_file
(
sgt01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sgt02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgt03       varchar2(10),            /*变更原因                               */
sgt04       varchar2(80),            /*变更原因说明                           */
sgt05       date DEFAULT sysdate NOT NULL, /*变更日期*/
sgt06       date,                    /*发放日期                               */
sgt07       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sgt08       varchar2(1) DEFAULT ' ' NOT NULL, /*发放码*/
sgtacti     varchar2(1),             /*资料有效码                             */
sgtdate     date,                    /*最近更改日                             */
sgtgrup     varchar2(10),            /*资料所属群组                           */
sgtmodu     varchar2(10),            /*资料更改者                             */
sgtuser     varchar2(10),            /*资料所有者                             */
sgtplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgtlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgtoriu     varchar2(10),            /*资料建立者                             */
sgtorig     varchar2(10)             /*资料建立部门                           */
);

alter table sgt_file add  constraint sgt_pk primary key  (sgt01,sgt02) enable validate;
grant select on sgt_file to tiptopgp;
grant update on sgt_file to tiptopgp;
grant delete on sgt_file to tiptopgp;
grant insert on sgt_file to tiptopgp;
grant index on sgt_file to public;
grant select on sgt_file to ods;
