/*
================================================================================
檔案代號:bwd_file
檔案名稱:保税料件期间统计资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bwd_file
(
bwd01       varchar2(40) NOT NULL,   /*料件编号                               */
bwd02       date NOT NULL,           /*生效日                                 */
bwd03       number(15,3),            /*内销数量(库存单位)                     */
bwd04       number(15,3),            /*外销数量(库存单位)                     */
bwd05       number(15,3),            /*报废数量                               */
bwd06       number(15,3),            /*外运数量(库存单位)                     */
bwd011      number(5) NOT NULL,      /*年度                                   */
bwdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwd_file add  constraint bwd_pk primary key  (bwd01,bwd02,bwd011) enable validate;
grant select on bwd_file to tiptopgp;
grant update on bwd_file to tiptopgp;
grant delete on bwd_file to tiptopgp;
grant insert on bwd_file to tiptopgp;
grant index on bwd_file to public;
grant select on bwd_file to ods;
