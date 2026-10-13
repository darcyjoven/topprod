/*
================================================================================
檔案代號:pnp_file
檔案名稱:关系人可冲销之客户编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnp_file
(
pnp01       varchar2(10) NOT NULL,   /*厂商号码                               */
                                     /*廠商號碼                               */
pnp02       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號                               */
pnp03       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
pnp04       varchar2(1),             /*No Use                                 */
pnp05       varchar2(1),             /*No Use                                 */
pnpacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pnpuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pnpgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pnpmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pnpdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pnporig     varchar2(10),            /*资料建立部门                           */
pnporiu     varchar2(10)             /*资料建立者                             */
);

alter table pnp_file add  constraint pnp_pk primary key  (pnp01,pnp02,pnp03) enable validate;
grant select on pnp_file to tiptopgp;
grant update on pnp_file to tiptopgp;
grant delete on pnp_file to tiptopgp;
grant insert on pnp_file to tiptopgp;
grant index on pnp_file to public;
grant select on pnp_file to ods;
