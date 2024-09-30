/*
  Warnings:

  - You are about to drop the column `commands` on the `Order` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Order" DROP CONSTRAINT "Order_clientId_fkey";

-- AlterTable
ALTER TABLE "Order" DROP COLUMN "commands",
ADD COLUMN     "orderCode" SERIAL NOT NULL,
ALTER COLUMN "clientId" DROP NOT NULL,
ALTER COLUMN "status" SET DEFAULT 'WAITING_PAYMENT';

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE SET NULL ON UPDATE CASCADE;
