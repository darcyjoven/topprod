/*
================================================================================
檔案代號:ofs_file
檔案名稱:佣金代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ofs_file
(
ofs01       varchar2(10) NOT NULL,   /*佣金编号                               */
                                     /*佣金代號                               */
ofs02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
ofs03       varchar2(1),             /*计算方式                               */
                                     /*Calculation Method (1:By Commision Define 2:By Customer 3:By Item)*/
ofs04       varchar2(1),             /*计算基准                               */
                                     /*計算基準                               */
                                     /*1.銷售數量                             */
                                     /*2.銷售金額                             */
                                     /*3.標準售價                             */
                                     /*4.利潤                                 */
ofs05       number(12,3),            /*比率                                   */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*此處的定義是每賣一個的佣金金額         */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs06       number(15,3),            /*基准一                                 */
                                     /*基準一                                 */
                                     /*當計算基準=1, 此欄為超出數量一         */
                                     /*當計算基準=2/3/4, 此欄為超出金額一     */
ofs07       number(12,3),            /*比率一                                 */
                                     /*當數量或金額超過基準一時, 超過部份的佣金*/
                                     /*使用比率一                             */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs08       number(15,3),            /*基准二                                 */
                                     /*基準二                                 */
                                     /*當計算基準=1, 此欄為超出數量二         */
                                     /*當計算基準=2/3/4, 此欄為超出金額二     */
ofs09       number(12,3),            /*比率二                                 */
                                     /*當數量或金額超過基準二時, 超過部份的佣金*/
                                     /*使用比率二                             */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs10       number(15,3),            /*基准三                                 */
                                     /*基準三                                 */
                                     /*當計算基準=1, 此欄為超出數量三         */
                                     /*當計算基準=2/3/4, 此欄為超出金額三     */
ofs11       number(12,3),            /*比率三                                 */
                                     /*當數量或金額超過基準三時, 超過部份的佣金*/
                                     /*使用比率三                             */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs12       number(15,3),            /*基准四                                 */
                                     /*基準四                                 */
                                     /*當計算基準=1, 此欄為超出數量四         */
                                     /*當計算基準=2/3/4, 此欄為超出金額四     */
ofs13       number(12,3),            /*比率四                                 */
                                     /*當數量或金額超過基準四時, 超過部份的佣金*/
                                     /*使用比率四                             */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs14       number(15,3),            /*基准五                                 */
                                     /*基準五                                 */
                                     /*當計算基準=1, 此欄為超出數量五         */
                                     /*當計算基準=2/3/4, 此欄為超出金額五     */
ofs15       number(12,3),            /*比率五                                 */
                                     /*當數量或金額超過基準五時, 超過部份的佣金*/
                                     /*使用比率五                             */
                                     /*當計算基準=1, 此欄為固定金額           */
                                     /*當計算基準=2/3/4, 此欄為佣金比率       */
ofs16       varchar2(1),             /*佣金计算币种                           */
                                     /*佣金計算幣別                           */
                                     /*1.原幣                                 */
                                     /*2.本幣                                 */
                                     /*3.指定幣別                             */
ofs17       varchar2(4),             /*佣金币种                               */
                                     /*佣金幣別                               */
ofs18       varchar2(1),             /*No Use                                 */
ofs19       varchar2(1),             /*No Use                                 */
ofs20       varchar2(1),             /*No Use                                 */
ofsacti     varchar2(1),             /*资料有效码                             */
ofsuser     varchar2(10),            /*资料所有者                             */
ofsgrup     varchar2(10),            /*资料所有群                             */
ofsmodu     varchar2(10),            /*资料更改者                             */
ofsdate     date,                    /*最近更改日                             */
ofsoriu     varchar2(10),            /*资料建立者                             */
ofsorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofs_file add  constraint ofs_pk primary key  (ofs01) enable validate;
grant select on ofs_file to tiptopgp;
grant update on ofs_file to tiptopgp;
grant delete on ofs_file to tiptopgp;
grant insert on ofs_file to tiptopgp;
grant index on ofs_file to public;
grant select on ofs_file to ods;
