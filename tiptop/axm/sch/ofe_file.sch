/*
================================================================================
檔案代號:ofe_file
檔案名稱:潜在客户等级异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ofe_file
(
ofe01       varchar2(10) NOT NULL,   /*潜在客户编号                           */
                                     /*潛在客戶編號                           */
ofe02       date NOT NULL,           /*等级调整日                             */
                                     /*等級調整日                             */
ofe03       varchar2(10),            /*变更员工编号                           */
                                     /*變更員工編號                           */
ofe04       varchar2(1),             /*变更前等级                             */
                                     /*變更前等級                             */
ofe05       varchar2(1),             /*变更后等级                             */
                                     /*變更后等級                             */
ofe06       varchar2(10),            /*变更前业务员编号                       */
                                     /*變更前業務員編號                       */
ofe07       varchar2(10),            /*变更后业务员编号                       */
                                     /*變更后業務員編號                       */
ofe08       varchar2(255),           /*等级调整原因                           */
                                     /*等級調整原因                           */
ofeacti     varchar2(1),             /*资料有效码                             */
ofeuser     varchar2(10),            /*资料所有者                             */
ofegrup     varchar2(10),            /*资料所有部门                           */
ofemodu     varchar2(10),            /*资料更改者                             */
ofedate     date,                    /*最近更改日                             */
ofeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofelegal    varchar2(10) NOT NULL,   /*所属法人                               */
ofeoriu     varchar2(10),            /*资料建立者                             */
ofeorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofe_file add  constraint ofe_pk primary key  (ofe01,ofe02) enable validate;
grant select on ofe_file to tiptopgp;
grant update on ofe_file to tiptopgp;
grant delete on ofe_file to tiptopgp;
grant insert on ofe_file to tiptopgp;
grant index on ofe_file to public;
grant select on ofe_file to ods;
