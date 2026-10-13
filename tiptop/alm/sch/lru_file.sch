/*
================================================================================
檔案代號:lru_file
檔案名稱:卡狀態異動維護單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lru_file
(
lru00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
lru01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lru02       varchar2(20),            /*会员编号                               */
lru03       varchar2(20),            /*卡种                                   */
lru04       varchar2(10),            /*理由码                                 */
lru05       date,                    /*单据日期                               */
lru06       varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
lru07       varchar2(10),            /*审核人                                 */
lru08       date,                    /*审核日期                               */
lru09       varchar2(50),            /*备注                                   */
lruacti     varchar2(1),             /*资料有效码                             */
lrucrat     date,                    /*资料创建日                             */
lrudate     date,                    /*最近更改日                             */
lrugrup     varchar2(10),            /*资料所有群                             */
lrulegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrumodu     varchar2(10),            /*资料更改者                             */
lruorig     varchar2(10),            /*资料建立部门                           */
lruoriu     varchar2(10),            /*资料建立者                             */
lruplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lruuser     varchar2(10),            /*资料所有者                             */
lru10       varchar2(20)             /*POS单号                                */
);

alter table lru_file add  constraint lru_pk primary key  (lru00,lru01) enable validate;
grant select on lru_file to tiptopgp;
grant update on lru_file to tiptopgp;
grant delete on lru_file to tiptopgp;
grant insert on lru_file to tiptopgp;
grant index on lru_file to public;
grant select on lru_file to ods;
