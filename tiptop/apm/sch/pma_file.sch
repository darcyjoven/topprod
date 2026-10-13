/*
================================================================================
檔案代號:pma_file
檔案名稱:付款方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pma_file
(
pma01       varchar2(10) NOT NULL,   /*付款方式                               */
pma02       varchar2(80),            /*付款方式说明                           */
                                     /*付款方式說明                           */
pma03       varchar2(1),             /*应付起算日基准                         */
                                     /*應付起算日基準                         */
                                     /*1.進貨日 4.進貨日次月初                */
                                     /*2.發票日 5.發票日次月初                */
                                     /*3.帳款日 6.帳款日次月初                */
pma04       number(9,4),             /*折扣率                                 */
pma05       number(5),               /*折扣有效之付款天数                     */
                                     /*/*Valid Paying Days for Discount       */
                                     /**There Will Be Discount Rate In Paying Days After Initial Date Base of A/P*/
pma06       number(9,4),             /*预付比率                               */
                                     /*預付比率                               */
pma07       number(9,4),             /*L/C 比率                               */
pma08       number(5),               /*起算日起加几天                         */
                                     /*起算日起加幾天                         */
pma09       number(5),               /*起算日起加几月                         */
                                     /*起算日起加幾月                         */
pma10       number(5),               /*票据起算日起加几天                     */
                                     /*票據起算日起加幾天    010507 mod       */
                                     /* 原為 允許票期天數                     */
pma11       varchar2(1),             /*类型                                   */
                                     /*類別 1.支票 2.轉帳 3.L/C               */
                                     /*     4.OA   6.DA   7.DP  8.LLC         */
pma12       varchar2(1),             /*票据到期日起算基准                     */
                                     /*票據到期日起算基準       010507 add    */
                                     /*1.進貨日 4.進貨日次月初                */
                                     /*2.發票日 5.發票日次月初                */
                                     /*3.帳款日 6.帳款日次月初                */
                                     /*7.應付款日 8.應付款日次月初            */
pma13       number(5),               /*票据起算日起加几月                     */
                                     /*票據起算日起加幾月      010507 add     */
pmaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmaorig     varchar2(10),            /*资料建立部门                           */
pmaoriu     varchar2(10)             /*资料建立者                             */
);

alter table pma_file add  constraint pma_pk primary key  (pma01) enable validate;
grant select on pma_file to tiptopgp;
grant update on pma_file to tiptopgp;
grant delete on pma_file to tiptopgp;
grant insert on pma_file to tiptopgp;
grant index on pma_file to public;
grant select on pma_file to ods;
