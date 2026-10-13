/*
================================================================================
檔案代號:obg_file
檔案名稱:产品价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obg_file
(
obg01       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
obg02       varchar2(40) NOT NULL,   /*产品编号                               */
                                     /*產品編號                               */
obg03       varchar2(4) NOT NULL,    /*销售单位                               */
                                     /*銷售單位 (不可輸入'*')                 */
obg04       varchar2(10) NOT NULL,   /*销售分类                               */
                                     /*銷售分類 ('*'表示全部)                 */
obg05       varchar2(6) NOT NULL,    /*价格条件                               */
                                     /*價格條件 ('*'表示全部)                 */
obg06       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號 ('*'表示全部)                 */
obg07       varchar2(10) NOT NULL,   /*国家编号                               */
                                     /*國別編號 ('*'表示全部)                 */
obg08       varchar2(10) NOT NULL,   /*区域编号                               */
                                     /*區域編號('*'表示全部)                  */
obg09       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別     (不可輸入'*')                 */
obg10       varchar2(4) NOT NULL,    /*税种                                   */
                                     /*稅別     ('*'表示全部)                 */
obg21       number(20,6) NOT NULL,   /*订价                                   */
                                     /*訂價                                   */
obguser     varchar2(10),            /*核价人员编号                           */
                                     /*核價人員編號                           */
obgdate     date,                    /*核价日期                               */
                                     /*核價日期                               */
obg22       varchar2(10) NOT NULL,   /*地区别                                 */
obgorig     varchar2(10),            /*资料建立部门                           */
obgoriu     varchar2(10)             /*资料建立者                             */
);

alter table obg_file add  constraint obg_pk primary key  (obg01,obg02,obg03,obg04,obg05,obg06,obg22,obg07,obg08,obg09,obg10) enable validate;
grant select on obg_file to tiptopgp;
grant update on obg_file to tiptopgp;
grant delete on obg_file to tiptopgp;
grant insert on obg_file to tiptopgp;
grant index on obg_file to public;
grant select on obg_file to ods;
