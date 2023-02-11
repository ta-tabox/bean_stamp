import type { FC } from 'react'

import { Tab, Tabs, TabList, TabPanel } from 'react-tabs'

import { FormContainer, FormMain } from '@/components/Form'
import { OfferSearchForm } from '@/features/search/components/organisms/OfferSearchForm'
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

      <div className="mt-8 h-80">
        <FormMain>
          <TabPanel>
            <RoasterSearchForm />
          </TabPanel>
          <TabPanel>
            <OfferSearchForm />
          </TabPanel>
        </FormMain>
      </div>
    </Tabs>
  </FormContainer>
)
