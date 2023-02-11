import type { FC } from 'react'

import { Tab, Tabs, TabList, TabPanel } from 'react-tabs'

import { FormContainer, FormMain } from '@/components/Form'
import { RoasterSearchForm } from '@/features/search/components/organisms/RoasterSearchFrom'

export const SearchFormTab: FC = () => (
  <FormContainer>
    <Tabs>
      <div className="">
        <TabList>
          <Tab>Roaster</Tab>
          <Tab>Offer</Tab>
        </TabList>
      </div>

      <div className="mt-8">
        <FormMain>
          <TabPanel>
            <RoasterSearchForm />
          </TabPanel>
          <TabPanel>
            <div>オファー検索フォーム</div>
          </TabPanel>
        </FormMain>
      </div>
    </Tabs>
  </FormContainer>
)
